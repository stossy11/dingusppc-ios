/*
DingusPPC - The Experimental PowerPC Macintosh emulator
Copyright (C) 2018-23 divingkatae and maximum
                      (theweirdo)     spatium

(Contact divingkatae#1017 or powermax#2286 on Discord for more info)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#ifndef NOMINMAX
#define NOMINMAX
#endif // NOMINMAX

#include <core/timermanager.h>
#include <cpu/ppc/ppcemu.h>
#include <devices/common/dmacore.h>
#include <devices/sound/soundserver.h>
#include <endianswap.h>

#include <algorithm>
#include <functional>
#include <loguru.hpp>
#ifdef _WIN32
#include <objbase.h>
#endif

#ifdef __APPLE__
#include <TargetConditionals.h>
#endif



typedef enum {
    SND_SERVER_DOWN = 0,
    SND_API_READY,
    SND_SERVER_UP,
    SND_STREAM_OPENED,
    SND_STREAM_CLOSED
} Status;

class SoundServer::Impl {
public:
    Status status = SND_SERVER_DOWN;

    uint32_t deterministic_poll_timer = 0;
    std::function<void()> deterministic_poll_cb;
};

SoundServer::SoundServer(): impl(std::make_unique<Impl>())
{
    supports_types(HWCompType::SND_SERVER);
    this->start();
}

SoundServer::~SoundServer()
{
    this->shutdown();
}

int SoundServer::start()
{
    int res;

#ifdef _WIN32
    CoInitialize(nullptr);
#endif

    impl->status = SND_SERVER_DOWN;

    impl->status = SND_API_READY;

    return 0;
}

void SoundServer::shutdown()
{
    switch (impl->status) {
    case SND_STREAM_OPENED:
        close_out_stream();
        /* fall through */
    case SND_STREAM_CLOSED:
        /* fall through */
    case SND_SERVER_UP:
        /* fall through */
    case SND_API_READY:
        break;
    case SND_SERVER_DOWN:
        // Nothing to do.
        break;
    }

    impl->status = SND_SERVER_DOWN;

    LOG_F(INFO, "Sound Server shut down.");
}

int SoundServer::open_out_stream(uint32_t sample_rate, DmaOutChannel *dma_ch)
{
#if !TARGET_OS_IOS
    if (is_deterministic) {
#endif
        impl->deterministic_poll_cb = [dma_ch] {
            if (!dma_ch->is_out_active()) {
                return;
            }
            // Drain the DMA buffer, but don't do anything else.
            int req_size = std::max(dma_ch->get_pull_data_remaining(), 1024);
            int out_size = 0;
            while (req_size > 0) {
                uint8_t *chunk;
                uint32_t chunk_size;
                if (!dma_ch->pull_data(req_size, &chunk_size, &chunk)) {
                    req_size -= chunk_size;
                } else {
                    break;
                }
            }
        };
        impl->status = SND_STREAM_OPENED;
        LOG_F(9, "Deterministic sound output callback set up.");
        return 0;
#if !TARGET_OS_IOS
    }
#endif

    impl->status = SND_STREAM_OPENED;

    return -1;
}

int SoundServer::start_out_stream()
{
    
#if !TARGET_OS_IOS
    if (is_deterministic) {
#endif
        LOG_F(9, "Starting sound output deterministic polling.");
        impl->deterministic_poll_timer = TimerManager::get_instance()->add_cyclic_timer(MSECS_TO_NSECS(10), impl->deterministic_poll_cb);
        return 0;
#if !TARGET_OS_IOS
    }
#endif
    return -1;
}

void SoundServer::close_out_stream()
{
#if !TARGET_OS_IOS
    if (is_deterministic) {
#endif
        LOG_F(9, "Stopping sound output deterministic polling.");
        TimerManager::get_instance()->cancel_timer(impl->deterministic_poll_timer);
        impl->status = SND_STREAM_CLOSED;
        return;
#if !TARGET_OS_IOS
    }
#endif
}

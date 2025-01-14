//
//  cubeb.mm
//  dingusppc-ios
//
//  Created by Stossy11 on 09/01/2025.
//


#import <Foundation/Foundation.h>
#include "cubeb.h"

int cubeb_init(cubeb **context, char const *context_name) {
    return CUBEB_OK;
}

char const * cubeb_get_backend_id(cubeb *context) {
    return "stub-backend";
}

void cubeb_destroy(cubeb *context) {
}

int cubeb_stream_init(cubeb *context, cubeb_stream **stream, char const *stream_name,
                      cubeb_stream_params stream_params, unsigned int latency,
                      cubeb_data_callback data_callback,
                      cubeb_state_callback state_callback,
                      void *user_ptr) {
    return CUBEB_OK;
}

void cubeb_stream_destroy(cubeb_stream *stream) {
}

int cubeb_stream_start(cubeb_stream *stream) {
    return CUBEB_OK;
}

int cubeb_stream_stop(cubeb_stream *stream) {
    return CUBEB_OK;
}

int cubeb_stream_get_position(cubeb_stream *stream, uint64_t *position) {
    return CUBEB_OK;
}

/*
 *  Base64Transcoder.h
 *  weibo4objc
 *
 *  Created by fanng yuan on 3/11/11.
 *  Copyright 2011 fanngyuan@sina. All rights reserved.
 *
 */

#include <stdlib.h>
#include <stdbool.h>

extern size_t EstimateBas64EncodedDataSize(size_t inDataSize);
extern size_t EstimateBas64DecodedDataSize(size_t inDataSize);

extern bool Base64EncodeData(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize);
extern bool Base64DecodeData(const void *inInputData, size_t inInputDataSize, void *ioOutputData, size_t *ioOutputDataSize);
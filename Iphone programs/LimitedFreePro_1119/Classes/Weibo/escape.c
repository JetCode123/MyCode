/*
 *  escape.c
 *  weibo4objc
 *
 *  Created by fanng yuan on 12/21/10.
 *  Copyright 2010 fanngyuan@sina. All rights reserved.
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "escape.h"

typedef enum {
	bool_false = 0,
	bool_true  = 1
} bool;

#  define false bool_false
#  define true  bool_true

#define TRUE true
#define FALSE false
#define MASK_UCHAR  0xFF

static bool isunreserved(unsigned char in)
{
	switch (in) {
		case '0': case '1': case '2': case '3': case '4':
		case '5': case '6': case '7': case '8': case '9':
		case 'a': case 'b': case 'c': case 'd': case 'e':
		case 'f': case 'g': case 'h': case 'i': case 'j':
		case 'k': case 'l': case 'm': case 'n': case 'o':
		case 'p': case 'q': case 'r': case 's': case 't':
		case 'u': case 'v': case 'w': case 'x': case 'y': case 'z':
		case 'A': case 'B': case 'C': case 'D': case 'E':
		case 'F': case 'G': case 'H': case 'I': case 'J':
		case 'K': case 'L': case 'M': case 'N': case 'O':
		case 'P': case 'Q': case 'R': case 'S': case 'T':
		case 'U': case 'V': case 'W': case 'X': case 'Y': case 'Z':
			return TRUE;
		default:
			break;
	}
	return FALSE;
}

char * urlEscape(const char *string, int inlength)
{
	size_t alloc = (inlength?(size_t)inlength:strlen(string))+1;
	char *ns;
	char *testing_ptr = NULL;
	unsigned char in; /* we need to treat the characters unsigned */
	size_t newlen = alloc;
	int strindex=0;
	size_t length;
	
	ns =(char *) malloc(alloc);
	if(!ns)
		return NULL;
	
	length = alloc-1;
	while(length--) {
		in = *string;
		
		if (isunreserved(in)) {
			/* just copy this */
			ns[strindex++]=in;
		}
		else {
			/* encode it */
			newlen += 2; /* the size grows with two, since this'll become a %XX */
			if(newlen > alloc) {
				alloc *= 2;
				testing_ptr =(char *) realloc(ns, alloc);
				if(!testing_ptr) {
					free( ns );
					return NULL;
				}
				else {
					ns = testing_ptr;
				}
			}
						
			snprintf(&ns[strindex], 4, "%%%02X", in);
			
			strindex+=3;
		}
		string++;
	}
	ns[strindex]=0; /* terminate it */
	return ns;
}

/*
 ** unsigned long to unsigned char
 */

unsigned char ultouc(unsigned long ulnum)
{
#ifdef __INTEL_COMPILER
#  pragma warning(push)
#  pragma warning(disable:810) /* conversion may lose significant bits */
#endif
	
	return (unsigned char)(ulnum & (unsigned long) MASK_UCHAR);
	
#ifdef __INTEL_COMPILER
#  pragma warning(pop)
#endif
}

char * urlUnescape(const char *string, int length,
                         int *olen)
{
	int alloc = (length?length:(int)strlen(string))+1;
	char *ns = malloc(alloc);
	unsigned char in;
	int strindex=0;
	unsigned long hex;
	
	if( !ns )
		return NULL;
	
	while(--alloc > 0) {
		in = *string;
		if(('%' == in) && isxdigit(string[1]) && isxdigit(string[2])) {
			/* this is two hexadecimal digits following a '%' */
			char hexstr[3];
			char *ptr;
			hexstr[0] = string[1];
			hexstr[1] = string[2];
			hexstr[2] = 0;
			
			hex = strtoul(hexstr, &ptr, 16);
			
			in = ultouc(hex); /* this long is never bigger than 255 anyway */
						
			string+=2;
			alloc-=2;
		}
		
		ns[strindex++] = in;
		string++;
	}
	ns[strindex]=0; /* terminate it */
	
	if(olen)
    /* store output size */
		*olen = strindex;
	return ns;
}


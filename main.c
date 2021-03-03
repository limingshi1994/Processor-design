/******************************************************************
 * This is the main file for the Software Sessions
 *
 */

#include <stdint.h>
#include <inttypes.h>

#include "common.h"
#include "mont_utils.h"
#include "1024mul.h"

// Uncomment for Session SW1
//extern void warmup();

// Uncomment for Session SW2 onwards
#include "mp_arith.h"
#include "montgomery.h"
#include "asm_func.h"


int main()
{

	init_platform();
    init_performance_counters(1);

    // Hello World template
    //----------------------
    xil_printf("Begin\n\r");


	

	/*
	//code for multiprecision addition;
    //xil_printf("Hello World!\n\r");

	xil_printf("Multiprecision Addition : ");
    uint32_t size = 32;
	uint32_t a[32]   = { 0x50b6e262, 0xab11c204, 0xa7bf8501, 0x4b3057fc, 0x091c2c94, 0x24c9f25a, 0x7efe51e6, 0x32c9e78f, 0x8245042d, 0xaa9666c1, 0xdf42a131, 0xe3a589f4, 0x89504ccf, 0x7c1784be, 0x1982ad1a, 0xd685b1d1, 0x49446e26, 0x3bd24c51, 0x1ddd527c, 0xb816d991, 0x669d054e, 0x5229107b, 0x77edc8e2, 0xe87859ca, 0x4d8c5654, 0x9ca94bb7, 0xb4ad76a3, 0xaed9754e, 0x3db3bd61, 0x1e60fcab, 0x92160876, 0xb723907f };
    uint32_t b[32]   = { 0x7e28a82b, 0x667a6624, 0x43b4f732, 0xfd81f57c, 0x8977809a, 0x358a5656, 0x75da2f7a, 0x0944be3f, 0x163c8e9f, 0x883e0eea, 0x1e5ba9b6, 0x117a4611, 0x0764e479, 0xac164c94, 0x040017fb, 0xd0eda810, 0x8d01d083, 0x16cea8a7, 0x40b0e42a, 0xdc4639c8, 0xd07f1029, 0x26ce0488, 0xb26a8f2e, 0x8c52eb3d, 0x58c66564, 0x95b105bd, 0x2298ae57, 0x9031d10a, 0xce3b4b49, 0x41f54a79, 0x95c766f0, 0xd10e07b4 };
    uint32_t res[size+1];
    mp_add(a, b, res, size);
    //xil_printf(a);
    //xil_printf(b);
    for(uint8_t i = 0; i <= size; i++)
    {
    	if(i==0)
			xil_printf("0x");
    	xil_printf("%08x", res[size-i]);
    }
    */


	/*
	//code for multiprecision subtraction;
	xil_printf("multiprecision subtraction : ");
	uint32_t size = 32;
	uint32_t a[32]   = { 0xaee66c08, 0x35233dcc, 0x2a299325, 0xd9e3d338, 0x42081c8b, 0xd57a9f22, 0xb62ef3a2, 0x2a166d34, 0x1717b18b, 0xc28518b0, 0xd1213e23, 0xcc1653c1, 0x01fdee5d, 0xcb1ec76c, 0xc64ca144, 0xd0df3f61, 0x9a92d2a5, 0x126a18ef, 0xf3e38e26, 0xa02c0ac2, 0xa3c8db54, 0x99f0c2dd, 0x1b7e7556, 0x21a39126, 0xc9f5b399, 0x90bb5146, 0x08066fca, 0x73174f16, 0xdb009cd3, 0xd473ffc8, 0x16270736, 0x82e9a839 };
	uint32_t b[32]   = { 0x855eb6f8, 0x6e9b6dff, 0xcd0636cc, 0xbf5773ea, 0xf72af8e6, 0xcbfa44fa, 0x5d58f185, 0xb35d23aa, 0xbfb8a381, 0xa7e23c00, 0x87c6781b, 0x1b1a3c5b, 0xdcc5432f, 0x7360269e, 0x2af92cef, 0xd5b62bf5, 0x9c45cf04, 0x5cfd6b26, 0xf48bb4b4, 0x9b2cb965, 0xa0579f37, 0xaef2010f, 0x955db2d8, 0xf9c705c4, 0x499c3848, 0x05408b7f, 0x0eca67a7, 0x37290375, 0x16fe438f, 0xb0ca5786, 0x26db96be, 0x84726aeb };
	uint32_t res[size];
	mp_sub(a, b, res, size);
	//xil_printf("the result should be : \n 0x346cb0219f6876a07f6b49589bfe4d42bc85112dc6015be02e1ff1f08ebe4706aa7b368dd8099426f0eb0810cbc165b0e4156c110ec7aa71c89f49ab9e7741b8819beb52eaacdf0fca00cf81e5046e860ac0adb85d7f285c26cc863829147b7af8e4e3053d359c69c71fb384131ef03ae201540f2859cce0da37d170a791d218");
	for(uint8_t i=0; i<size; i++)
	{
		if(i==0)
			xil_printf("0x");
		xil_printf("%08x", res[size -1 -i]);
	}
	*/

	/*
	//code for modular addition;
	xil_printf("modular addition : ");
	uint32_t size = 32;
	uint32_t a[32] = { 0xa2e47eba, 0xdb5e3e7d, 0x5fd9a7cb, 0x9e7a37c3, 0x4dc37416, 0x834fe315, 0x0080dbac, 0x47280a4d, 0x722dc3dd, 0x7f0ca6f4, 0x7f0da3db, 0xfc20cbb9, 0xb749699e, 0xc5abc925, 0x8bc67669, 0x23a30d3f, 0xffe44e1c, 0xdb22d6ee, 0x5dc3d3b3, 0xfe7e980d, 0x894075d2, 0xdeabe7c4, 0x58042c3b, 0x1cc18107, 0xf0abb2e1, 0x7bd31dc0, 0x72355db9, 0xf55a0178, 0x99f5d831, 0x12ccb47a, 0x44eef089, 0x81bf5831 };
	uint32_t b[32] = { 0xe47d092a, 0xd7615ed9, 0xa8aff661, 0xc3d7bb8c, 0x2d22b31c, 0x5050b808, 0xb0bc44bb, 0x93e46f4f, 0xac0332e5, 0x81ad7f85, 0x23de9197, 0x4b35f0a2, 0x6303744a, 0x615740bf, 0x54ebbaef, 0xf36273c2, 0xaf0d1080, 0x4740c9d6, 0x458e6699, 0xaaa1040b, 0x614df162, 0xaf7fe30d, 0xac73e3ed, 0x49204145, 0x1653523c, 0x5ee4f3b1, 0x2b3f4339, 0x5b9a2426, 0x62e3ffb3, 0xf4c32df1, 0x94f2db82, 0x80deb209 };
	uint32_t n[32] = { 0xb2e52d11, 0x8f850a5f, 0x08edfb0c, 0x4f02a1ac, 0xdd070636, 0x6c59cfc8, 0x16a40db7, 0x85bba009, 0x598eba07, 0x5d0fa3cc, 0x32bc6fb5, 0x4aa27cd0, 0x0928454e, 0x027d3081, 0xd1caec35, 0xa98e4223, 0x533983de, 0x36370bb4, 0xe8b0b4c6, 0xfe3655ab, 0x27a4a51e, 0xb403c449, 0xa679cf3b, 0xc1fc4391, 0x884e5080, 0xa65d4d30, 0xcd90ed67, 0x55fcb457, 0x989d6f4c, 0x0303d70e, 0x9a09328e, 0x82260dd0 };
	uint32_t res[32];
	mod_add(a, b, n, res, size);
	//xil_printf("the result should be : \n 0x8077fc6a3fd8997e048c0b5d643c6898faf77146cfe3b38b345ac4417eb0b49ca3e57ebb5dfe40edda280688c2e9c216aae9466cbaa18586ec2c95115bb7dabe6d773ede0ee745242485d9641124989afcb43f8b702fc5bda3aa82adc4a23cbb5550d9939a9912b06746cb549ddf20fd134f51a3ff9ba321233a92f7d47c5ad3")
	for(uint8_t i=0; i<size; i++)
	{
		if(i==0)
			xil_printf("0x");
		xil_printf("%08x", res[size -1 -i]);
	}
	*/


	/*

	//code for modular subtraction;
	xil_printf("modular subtraction : ");
	uint32_t size = 32;
	uint32_t a[32]   = { 0xaee66c08, 0x35233dcc, 0x2a299325, 0xd9e3d338, 0x42081c8b, 0xd57a9f22, 0xb62ef3a2, 0x2a166d34, 0x1717b18b, 0xc28518b0, 0xd1213e23, 0xcc1653c1, 0x01fdee5d, 0xcb1ec76c, 0xc64ca144, 0xd0df3f61, 0x9a92d2a5, 0x126a18ef, 0xf3e38e26, 0xa02c0ac2, 0xa3c8db54, 0x99f0c2dd, 0x1b7e7556, 0x21a39126, 0xc9f5b399, 0x90bb5146, 0x08066fca, 0x73174f16, 0xdb009cd3, 0xd473ffc8, 0x16270736, 0x82e9a839 };
	uint32_t b[32]   = { 0x855eb6f8, 0x6e9b6dff, 0xcd0636cc, 0xbf5773ea, 0xf72af8e6, 0xcbfa44fa, 0x5d58f185, 0xb35d23aa, 0xbfb8a381, 0xa7e23c00, 0x87c6781b, 0x1b1a3c5b, 0xdcc5432f, 0x7360269e, 0x2af92cef, 0xd5b62bf5, 0x9c45cf04, 0x5cfd6b26, 0xf48bb4b4, 0x9b2cb965, 0xa0579f37, 0xaef2010f, 0x955db2d8, 0xf9c705c4, 0x499c3848, 0x05408b7f, 0x0eca67a7, 0x37290375, 0x16fe438f, 0xb0ca5786, 0x26db96be, 0x84726aeb };
	uint32_t n[32]   = { 0xe8c48a51, 0x1b8dee14, 0x862f952f, 0x8f6b8168, 0x4ea4e323, 0xd35aa574, 0x87f03b6a, 0x3bd7a5a6, 0x8d9479b6, 0xfa121d94, 0x1872cf6f, 0xbd86b870, 0xf4b9ae66, 0x08e92fb5, 0x717bc726, 0x48d634f3, 0x11a967ba, 0x7c79d4b0, 0xc516ec1f, 0x891f3089, 0x15cb661e, 0x1c8b0888, 0x631ec6e3, 0xc02484c2, 0x79b4f388, 0x0d6cba7c, 0x8b63007a, 0x95544192, 0x41425a07, 0x3ae0b97e, 0xc48ce827, 0x9fa0fb98 };
	uint32_t res[32];
	mod_sub(a, b, n, res, size);
	//result should be: 0x9e1838e6b3d8589f5e8a61c10544b34bd1428d33849f089d98e78043fa0e6ed8e8011023e93f89610789ca56193ca23b8e1e81e6c46ec59131e682790ff66b5b43ff48600ccf3b7b60a7d08319f259956e82cfd661cd957814b4fa43e4f387bfb290ef30e0c63d87dcdaff9b998206c8a9f7e0b5e352f187e215bde2124c3f61
	for(uint8_t i=0; i<size; i++)
	{
		if(i==0)
			xil_printf("0x");
		xil_printf("%08x", res[size -1 -i]);
	}

	*/


    /*

	//code for montgomery multiplication;
	uint32_t size = 32;
	uint32_t res[33];

	uint32_t a[32]         = { 0xa2e47eba, 0xdb5e3e7d, 0x5fd9a7cb, 0x9e7a37c3, 0x4dc37416, 0x834fe315, 0x0080dbac, 0x47280a4d, 0x722dc3dd, 0x7f0ca6f4, 0x7f0da3db, 0xfc20cbb9, 0xb749699e, 0xc5abc925, 0x8bc67669, 0x23a30d3f, 0xffe44e1c, 0xdb22d6ee, 0x5dc3d3b3, 0xfe7e980d, 0x894075d2, 0xdeabe7c4, 0x58042c3b, 0x1cc18107, 0xf0abb2e1, 0x7bd31dc0, 0x72355db9, 0xf55a0178, 0x99f5d831, 0x12ccb47a, 0x44eef089, 0x81bf5831 };
	uint32_t b[32]         = { 0xe47d092a, 0xd7615ed9, 0xa8aff661, 0xc3d7bb8c, 0x2d22b31c, 0x5050b808, 0xb0bc44bb, 0x93e46f4f, 0xac0332e5, 0x81ad7f85, 0x23de9197, 0x4b35f0a2, 0x6303744a, 0x615740bf, 0x54ebbaef, 0xf36273c2, 0xaf0d1080, 0x4740c9d6, 0x458e6699, 0xaaa1040b, 0x614df162, 0xaf7fe30d, 0xac73e3ed, 0x49204145, 0x1653523c, 0x5ee4f3b1, 0x2b3f4339, 0x5b9a2426, 0x62e3ffb3, 0xf4c32df1, 0x94f2db82, 0x80deb209 };
	uint32_t n[32]         = { 0xb2e52d11, 0x8f850a5f, 0x08edfb0c, 0x4f02a1ac, 0xdd070636, 0x6c59cfc8, 0x16a40db7, 0x85bba009, 0x598eba07, 0x5d0fa3cc, 0x32bc6fb5, 0x4aa27cd0, 0x0928454e, 0x027d3081, 0xd1caec35, 0xa98e4223, 0x533983de, 0x36370bb4, 0xe8b0b4c6, 0xfe3655ab, 0x27a4a51e, 0xb403c449, 0xa679cf3b, 0xc1fc4391, 0x884e5080, 0xa65d4d30, 0xcd90ed67, 0x55fcb457, 0x989d6f4c, 0x0303d70e, 0x9a09328e, 0x82260dd0 };
	uint32_t n_prime[32]   = { 0xfb5c9c0f, 0xd3cbec85, 0x3a126c50, 0x0f85259a, 0xb93b900a, 0x89feafbe, 0x30847469, 0x0a87f885, 0x9d5bfa86, 0xec1adae0, 0x448a3dac, 0xa7194e08, 0x61c37198, 0xd5eff8a8, 0xf96efef1, 0x473d83aa, 0xe7c048dd, 0xb1893377, 0xc843e910, 0xcd3b86d2, 0x2119b9dd, 0x6caed27a, 0x7ebcc873, 0x2019cd09, 0x240e3495, 0x040754fb, 0xdfef2830, 0x32a287d7, 0x8e79f7e4, 0x3daeb7e0, 0xbeaeac00, 0x376725cd };

	
START_TIMING
	//montMul(a, b, n, n_prime, res, size);
	montMulOpt(a, b, n, n_prime, res, size);
STOP_TIMING	
	//size
	size = 32;
	*/



	/*
	//test _mul;
	uint8_t sizemul = 2;
	uint32_t a = 0xffffffff;
	uint32_t b = 0x00000002;
	uint32_t* res;
	res = _32mul(a, b);
	for(uint8_t i=0; i<sizemul; i++)
	{
		if(i==0)
			xil_printf("0x");
		xil_printf("%08x", res[sizemul -1 -i]);
	}

	*/


	/*

	//test ADD;
	uint8_t sizeadd = 3;
	uint32_t t[3] = {0xffffffff, 0xffffffff, 0x12345678};
	uint8_t i = 0;
	uint32_t C = 0x00000003;
	ADD(t, i, C);
	for(uint8_t i=0; i<sizeadd; i++)
	{
		if(i==0)
			xil_printf("0x");
		xil_printf("%08x", t[sizeadd -1 -i]);
	}
	*/



	/*
	//test SUB_COND;
	uint32_t u[3] = {0xffffffff, 0xeeeeeeee, 0x00000005};
	uint32_t n[3] = {0x11111111, 0x11111111, 0x00000000};
	uint32_t dum[2];
	uint32_t* t1 = SUB_COND(u,n,2,dum);
	for(uint8_t i=0; i<2; i++)
	{
		if(i==0)
			xil_printf("0x");
		xil_printf("%08x", t1[1-i]);
	}


	*/

    uint32_t res[65];
    uint32_t Qc[32] =
    {
    0x0a5f5217, 0xd47c24d0, 0x96ee5b44, 0xc7d8a995, 0xf02901f3, 0x79166228,
        0x8b1f2d67, 0xe7f1bdfe, 0x2e08f01c, 0xe1578d01, 0x4d3f190a,
        0x2dfe99d2, 0x7b0102b8, 0x0081f65c, 0x87ef44ff, 0x3d2370e5,
        0xdf1f405d, 0x9e4c2aef, 0xc79c5edc, 0x7a6a05d9, 0x2cd61c2a,
        0xfb3979ad, 0x7965fd10, 0xb9d0c1f9, 0xac640f88, 0x7d241b07,
        0x9bb16ea2, 0xf99101ca, 0x0ff42aba, 0xad222077, 0x4e65b8b1, 0xbd93f12a};


    uint32_t hc[32] =
    {
    0x840e60ca, 0x704bd72c, 0x47576d0a, 0x86ee20e8, 0xb18bb774, 0x8815c114,
        0x132af860, 0xd6f6f55e, 0x90050eb4, 0x88d21d21, 0xe844f171,
        0x05b086d7, 0x45efd8df, 0x20469d22, 0x3aa93bce, 0x694351c3,
        0xce13e007, 0x9b46f071, 0xba976763, 0x1fd462d4, 0xc8f73775,
        0x13268f2e, 0xcf33d810, 0xbad1a981, 0x6dd4ca0a, 0x36912b33,
        0x59240094, 0x45d13e5f, 0xde0d5f8e, 0x31657bc4, 0xd0b29a59, 0x6c146d43};

        Mul_Big(Qc, hc, res);
        for(uint32_t i=0; i<65; i++){
			xil_printf("0x");
		xil_printf("%08x", hc[32 -i]);
        }


/*


//print;
	for(uint8_t i=0; i<size; i++)
	{
		if(i==0)
			xil_printf("0x");
		xil_printf("%08x", res[size -1 -i]);
	}


*/


	xil_printf("\nEnd\n\r");

    // SW1: warmup exercise
    //----------------------
    //warmup();

    cleanup_platform();

    return 0;
}

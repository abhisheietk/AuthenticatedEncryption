#include <stdio.h>
#include <stdlib.h>
#include "encrypt.c"

//typedef unsigned int u32;
//typedef unsigned long long int u64;


int main()
{

u8 *m, *c, *ad, Key[16], Npub[8], Nsec[8];
u64 mlen, clen, adlen, block_msg, block_ad;
int i, j, value;
FILE *fp, *fp1, *fp2;

fp1 = fopen("msg.txt","r");
fp2 = fopen("ad.txt","r");
fp = fopen("ciphertext.txt","w");
printf("\nEnter the Message Length\n");
scanf("%llu", &mlen);

printf("\nEnter the Associated Data Length\n");
scanf("%llu", &adlen);

m = (u8*)malloc(mlen*sizeof(u8));
ad = (u8*)malloc(adlen*sizeof(u8));
c = (u8*)malloc((mlen+67108864)*sizeof(u8));

printf("\n Enter the Message\n");
for(i=0;i<mlen;i++) fscanf(fp1,"%u", &m[i]);

printf("\n Enter the Associated Data\n");
for(i=0;i<adlen;i++) fscanf(fp2,"%u", &ad[i]);

clen=0;

/*
m[0]=ad[0]=128;
for(i=1;i<6;i++)
{
 ad[i]=0;
}
for(i=1;i<55;i++)
{
 m[i]=0;
}
m[55]=1;
ad[6]=0;
//printf("Enter the Message");

//for(i=0;i<mlen;i++)
//{
//scanf("%u",&m[i]);
//}
*/



for(i=0;i<16;i++)
{
Key[i]=0;  //We have Set Zero Key
}


for(i=0;i<8;i++)
{
Npub[i]=0;
Nsec[i]=0;
}

crypto_aead_encrypt(c, &clen, m, mlen, ad, adlen, Nsec, Npub, Key);

printf("\n\nThe Ciphertext length is %llu \n\n", clen);
printf("\n\nThe Ciphertext is\n\n");

for(i=0;i<clen;i++)
{
for(j=0;j<8;j++)
fprintf(fp, "%u",(c[i]>>(7-j))&1);
fprintf(fp, "\n");
}

for(i=0;i<16;i++)
{
Key[i]=0;
}

mlen=0;
value = crypto_aead_decrypt(m, &mlen, Nsec, c, clen, ad, adlen, Npub, Key);

printf("\n\nThe Decrypted Message is \n\n");

for(i=0;i<mlen;i++)
{
printf("%u\n",m[i]);
}

if(!value)
{
printf("\n\n\nFull Message has been verified!!!!!!!!!!!\n\n\n");
}

else
{
printf("\n\n\nFull Message has not been verified!!!!!!!!!!!!\n\n\n");
}
return 0;
}
  


package com.urbanspork.common.cipher.impl;

import org.bouncycastle.crypto.engines.CamelliaEngine;
import org.bouncycastle.crypto.modes.CFBBlockCipher;

import com.urbanspork.common.cipher.Cipher;
import com.urbanspork.common.cipher.ShadowsocksCipher;
import com.urbanspork.common.cipher.base.BaseStreamCipher;

public class Camellia_256_CFB implements ShadowsocksCipher {

    private Cipher encrypter = new BaseStreamCipher(new CFBBlockCipher(new CamelliaEngine(), 128), 16);
    private Cipher decrypter = new BaseStreamCipher(new CFBBlockCipher(new CamelliaEngine(), 128), 16);

    @Override
    public String getName() {
        return "camellia-256-cfb";
    }

    @Override
    public Cipher encrypter() {
        return encrypter;
    }

    @Override
    public Cipher decrypter() {
        return decrypter;
    }

    @Override
    public int getKeySize() {
        return 32;
    }

}
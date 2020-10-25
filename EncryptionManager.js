"use strict";

const crypto = require('crypto');
const fs = require('fs');
const { symetricKeyPath } = require('../config');

class EncryptionManager {
    constructor() {
        this.cipher = null;
    }

    static saveKey(keyValue, keyPath) {

        fs.writeFileSync(keyPath, keyValue);

    }

    importPublicKey(publicKey) {
        this.cipher = crypto.createPublicKey({
            key: publicKey,
            format: 'pem',
            type: 'pkcs1'
        });
    }

    importPrivateKey({ privateKey, passphrase }) {
        this.cipher = crypto.createPrivateKey({
            key: privateKey,
            format: "pem",
            type: "pkcs1",
            passphrase
        });
    }

    saveSymetricKey(symetricKey) {
        var encryptedKey;
        if (this.cipher) {
            symetricKey = Buffer.from(encryptedKey, 'utf8');
            encryptedKey = crypto.publicEncrypt(this.cipher, symetricKey);
            this.saveKey(encryptedKey, symetricKeyPath);
            return;
        } else {
            throw new Exception("É NECESSÁRIO IMPORTAR A CHAVE PUBLICA DO SERVIDOR ANTES DE ENCRIPTAR A CHAVE SIMÉTRICA LOCAL");
        }
    }

    loadSymetricKey() {
        var symetricKey, encSymetricKey;
        if (this.cipher) {
            encSymetricKey = fs.readFileSync(symetricKeyPath);

            if (!Buffer.isBuffer(encSymetricKey)) {
                encSymetricKey = Buffer.from(encSymetricKey, 'utf8');
            }

            symetricKey = crypto.privateDecrypt(this.cipher, encSymetricKey);
            const keyArr = symetricKey.toString('utf8').split(':');
            const IV = keyArr[0],
                KEY = keyArr[1];
            return { IV, KEY };
        } else {
            throw new Exception("É NECESSÁRIO IMPORTAR A CHAVE PRIVADA DO SERVIDOR ANTES DE DECRIPTAR A CHAVE SIMÉTRICA LOCAL");
        }
    }
}

module.exports = EncryptionManager;
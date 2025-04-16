package com.grin.edgeplatform.utils;

import org.springframework.stereotype.Component;
import lombok.AllArgsConstructor;

import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import javax.crypto.Cipher;
import java.util.Base64;
import java.security.*;

@Component
@AllArgsConstructor
public class RSAUtils {

  KeyPairGenerator keyGenerator;
  KeyFactory keyFactory;

  public KeyPair generateKeyPair() {
    keyGenerator.initialize(2048);
    return keyGenerator.generateKeyPair();
  }

  public String getPublicKeyAsString(PublicKey publicKey) {
    RSAPublicKey rsaPublicKey = (RSAPublicKey) publicKey;
    return Base64.getEncoder().encodeToString(rsaPublicKey.getEncoded());
  }

  public String getPrivateKeyAsString(PrivateKey privateKey) {
    RSAPrivateKey rsaPrivateKey = (RSAPrivateKey) privateKey;
    return Base64.getEncoder().encodeToString(rsaPrivateKey.getEncoded());
  }


  public String decryptWithPrivateKey(String encryptedDataBase64, String privateKeyBase64) throws Exception {
    // Decode the private key from Base64
    byte[] privateKeyBytes = Base64.getDecoder().decode(privateKeyBase64);
    RSAPrivateKey privateKey = (RSAPrivateKey) keyFactory.generatePrivate(new java.security.spec.PKCS8EncodedKeySpec(privateKeyBytes));

    // Decode the encrypted data from Base64
    byte[] encryptedData = Base64.getDecoder().decode(encryptedDataBase64);

    // Initialize the Cipher for RSA decryption
    Cipher cipher = Cipher.getInstance("RSA");
    cipher.init(Cipher.DECRYPT_MODE, privateKey);

    // Decrypt the data
    byte[] decryptedData = cipher.doFinal(encryptedData);

    // Convert decrypted byte array to string (assuming it's text)
    return new String(decryptedData);
  }
}

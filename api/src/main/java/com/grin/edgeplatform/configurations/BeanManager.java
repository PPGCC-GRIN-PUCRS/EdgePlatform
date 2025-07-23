package com.grin.edgeplatform.configurations;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Bean;
import org.modelmapper.ModelMapper;

import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;
import java.security.KeyFactory;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;

@Configuration
public class BeanManager {

  @Bean
  public ModelMapper modelMapper() {
    return new ModelMapper();
  }

  @Bean
  public KeyPairGenerator keygen() throws NoSuchAlgorithmException {
    return KeyPairGenerator.getInstance("RSA");
  }

  @Bean
  public KeyFactory keyFactory() throws NoSuchAlgorithmException {
    return KeyFactory.getInstance("RSA");
  }

}

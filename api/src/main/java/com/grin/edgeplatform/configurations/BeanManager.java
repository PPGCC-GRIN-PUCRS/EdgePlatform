package com.grin.edgeplatform.configurations;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
import org.springframework.boot.web.client.RestTemplateBuilder;
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
  ModelMapper modelMapper() {
    return new ModelMapper();
  }

  @Bean
  KeyPairGenerator keygen() throws NoSuchAlgorithmException {
    return KeyPairGenerator.getInstance("RSA");
  }

  @Bean
  KeyFactory keyFactory() throws NoSuchAlgorithmException {
    return KeyFactory.getInstance("RSA");
  }

  @Bean
  RestTemplate restTemplate() {
    return new RestTemplate();
  }

}

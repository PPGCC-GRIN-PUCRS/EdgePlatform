package com.grin.edgeplatform.configurations;

import io.micrometer.core.instrument.binder.system.ProcessorMetrics;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Slf4j
@Configuration
public class MetricsConfig {

  @Bean
  public ProcessorMetrics processorMetrics() {
    try {
      return new ProcessorMetrics();
    } catch (Exception e) {
      log.error("⚠️ ProcessorMetrics initialization failed: {}", e.getMessage());
      return null;
    }
  }
}


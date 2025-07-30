package com.grin.edgeplatform.services;

import jakarta.validation.constraints.Null;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;
import java.util.Objects;

@Slf4j
@Service
@RequiredArgsConstructor
public class AgentService {

    private final RestTemplate rest;

    @Value("${application.agent.install.script:#{null}}")
    String installScriptURL;

    @Value("${application.api.version:vNull}")
    String apiVersion;

    @CacheEvict(value = "installScript")
    public void clearInstallScriptCache() {
    }

    @Cacheable(value = "installScript")
    public String getInstallScript() throws InterruptedException {
        String rawScript = "";

        do {
          try {
            rawScript = """
            #!/bin/bash

            # Script acquired over API %s at %s

            %s
            """.formatted(
              apiVersion,
              LocalDateTime.now(),
              Objects.requireNonNull(rest.getForObject(installScriptURL, String.class))
                .replaceFirst("#!/bin/bash", "")
            );
          } catch (RestClientException e) {
            log.debug(e.getMessage());
            Thread.sleep(600);
          }
        } while (rawScript.isEmpty());

        return rawScript;
    }

}
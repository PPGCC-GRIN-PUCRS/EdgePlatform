package com.grin.edgeplatform.services;

import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;

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

    @Value("${application.agent.version:vNull}")
    String agentVersion;


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
            # Agent version %s

            %s
            """.formatted(
              apiVersion,
              LocalDateTime.now(),
              agentVersion,
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

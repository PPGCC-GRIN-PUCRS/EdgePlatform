package com.grin.edgeplatform;


import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.boot.context.event.ApplicationPreparedEvent;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.junit.jupiter.api.condition.DisabledInNativeImage;
import org.springframework.core.env.EnumerablePropertySource;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.core.env.ConfigurableEnvironment;
import com.grin.edgeplatform.repositories.NodeRepository;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.context.ApplicationListener;
import org.springframework.core.env.PropertySource;
import org.springframework.web.client.RestTemplate;
import org.testcontainers.DockerClientFactory;
import org.apache.commons.logging.LogFactory;
import org.jetbrains.annotations.NotNull;
import org.junit.jupiter.api.BeforeAll;
import org.apache.commons.logging.Log;
import org.junit.jupiter.api.Test;
import org.springframework.http.*;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT, properties = {
  "spring.docker.compose.skip.in-tests=false",
  "spring.docker.compose.profiles.active=postgres"
})
@ActiveProfiles("postgres")
@DisabledInNativeImage
class PostgresIntegrationTest {

  @LocalServerPort
  int port;

  @Autowired
  NodeRepository nodeRepository;

  @Autowired
  private RestTemplateBuilder builder;

  @BeforeAll
  static void available() {
    assumeTrue(DockerClientFactory.instance().isDockerAvailable(), "Docker not available");
  }

  public static void main(String[] args) {
    new SpringApplicationBuilder(EdgeplatformApplication.class)
      .profiles("postgres")
      .properties(
        "spring.docker.compose.profiles.active=postgres"
      )
      .listeners(new PropertiesLogger())
      .run(args);
  }

  @Test
  void testFindAll() throws Exception {
    nodeRepository.findAll();
    nodeRepository.findAll(); // served from cache
  }

  @Test
  void testNodeStatusNotification() {
    RestTemplate template = builder.rootUri("http://localhost:" + port).build();
    // Create the request body as a MultiValueMap
    HttpHeaders requestHeaders = new HttpHeaders();
    requestHeaders.setContentType(MediaType.APPLICATION_JSON);
    requestHeaders.setAccept(List.of(MediaType.APPLICATION_JSON));

    Map<String, Object> body = Map.of("temp", "50 °C");

    // Create an HttpEntity with the headers and body
    HttpEntity<?> httpEntity = new HttpEntity<>(body, requestHeaders);

    // Define the endpoint URI
    String url = "http://localhost:" + port + "/notify";

    // Execute the request and get the response
    ResponseEntity<String> result = template.exchange(url, HttpMethod.POST, httpEntity, String.class);

    assertThat(result.getStatusCode()).isEqualTo(HttpStatus.OK);
  }



  static class PropertiesLogger implements ApplicationListener<ApplicationPreparedEvent> {

    private static final Log log = LogFactory.getLog(PropertiesLogger.class);

    private ConfigurableEnvironment environment;

    private boolean isFirstRun = true;

    @Override
    public void onApplicationEvent(@NotNull ApplicationPreparedEvent event) {
      if (isFirstRun) {
        environment = event.getApplicationContext().getEnvironment();
        printProperties();
      }
      isFirstRun = false;
    }

    public void printProperties() {
      for (EnumerablePropertySource<?> source : findPropertiesPropertySources()) {
        log.info("PropertySource: " + source.getName());
        String[] names = source.getPropertyNames();
        Arrays.sort(names);
        for (String name : names) {
          String resolved = environment.getProperty(name);

          assertNotNull(resolved, "resolved environment property: " + name + " is null.");

          Object sourceProperty = source.getProperty(name);

          assertNotNull(sourceProperty, "source property was expecting an object but is null.");

          assertNotNull(sourceProperty.toString(), "source property toString() returned null.");

          String value = sourceProperty.toString();
          if (resolved.equals(value)) {
            log.info(name + "=" + resolved);
          }
          else {
            log.info(name + "=" + value + " OVERRIDDEN to " + resolved);
          }
        }
      }
    }

    private List<EnumerablePropertySource<?>> findPropertiesPropertySources() {
      List<EnumerablePropertySource<?>> sources = new LinkedList<>();
      for (PropertySource<?> source : environment.getPropertySources()) {
        if (source instanceof EnumerablePropertySource enumerable) {
          sources.add(enumerable);
        }
      }
      return sources;
    }

  }

}

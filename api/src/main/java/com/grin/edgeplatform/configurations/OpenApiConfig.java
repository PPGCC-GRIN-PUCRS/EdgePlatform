package com.grin.edgeplatform.configurations;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
// import io.swagger.v3.oas.annotations.OpenAPIDefinition;
// import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.License;

@Configuration
public class OpenApiConfig {

    @Value("${application.api.version}")
    String apiVersion;

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Edge Platform API")
                        .description(
                                "API para gerenciamento de agentes e operações na plataforma de gestão de nodos e clusters edge computing.")
                        .version(apiVersion)
                        .contact(new Contact()
                                .name("Suporte Grin EdgePlatform")
                                .url("https://grin.logiclabsoftwares.com/suporte")
                                .email("grin@logiclabsoftwares.com"))
                        .license(new License()
                                .name("Apache 2.0")
                                .url("https://www.apache.org/licenses/LICENSE-2.0")));
    }
}

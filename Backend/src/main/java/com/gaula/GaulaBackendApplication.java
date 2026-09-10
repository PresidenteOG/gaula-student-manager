package com.gaula;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.web.config.EnableSpringDataWebSupport;

/**
 * Punto de entrada principal de la aplicación GAULA.
 *
 * @SpringBootApplication activa:
 *   - @ComponentScan: escanea todos los beans en el paquete com.gaula
 *   - @EnableAutoConfiguration: configura Spring según las dependencias del classpath
 *   - @Configuration: permite definir beans adicionales aquí si fuese necesario
 *
 * Para arrancar: mvn spring-boot:run (perfil dev con H2 por defecto)
 */
@SpringBootApplication
@EnableSpringDataWebSupport(pageSerializationMode = EnableSpringDataWebSupport.PageSerializationMode.VIA_DTO)
public class GaulaBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(GaulaBackendApplication.class, args);
    }
}

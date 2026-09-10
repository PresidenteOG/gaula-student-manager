package com.gaula.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Excepción lanzada cuando un recurso solicitado no existe en la BBDD.
 * Produce una respuesta HTTP 404 Not Found automáticamente via @ResponseStatus.
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class ResourceNotFoundException extends RuntimeException {

    public ResourceNotFoundException(String message) {
        super(message);
    }

    /**
     * Constructor conveniente para indicar la entidad y el ID buscado.
     * Ejemplo: new ResourceNotFoundException("Alumno", "id", 42)
     * → "Alumno no encontrado con id: 42"
     */
    public ResourceNotFoundException(String resourceName, String fieldName, Object fieldValue) {
        super(String.format("%s no encontrado con %s: %s", resourceName, fieldName, fieldValue));
    }
}

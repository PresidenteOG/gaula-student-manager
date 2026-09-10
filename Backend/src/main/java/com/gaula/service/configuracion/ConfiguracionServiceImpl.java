package com.gaula.service.configuracion;

import com.gaula.entity.ConfiguracionSistema;
import com.gaula.repository.ConfiguracionSistemaRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Implementación del servicio de Configuración del Sistema.
 * Patrón upsert: si la clave existe, actualiza; si no, crea.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ConfiguracionServiceImpl implements ConfiguracionService {

    private final ConfiguracionSistemaRepository configRepository;

    @Override
    @Transactional(readOnly = true)
    public Optional<String> obtenerValor(String clave) {
        return configRepository.findByClave(clave).map(ConfiguracionSistema::getValor);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<ConfiguracionSistema> obtenerPorClave(String clave) {
        return configRepository.findByClave(clave);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ConfiguracionSistema> findAll() {
        return configRepository.findAll();
    }

    @Override
    @Transactional
    public ConfiguracionSistema guardar(String clave, String valor, String descripcion) {
        ConfiguracionSistema config = configRepository.findByClave(clave)
            .orElseGet(() -> ConfiguracionSistema.builder().clave(clave).build());

        config.setValor(valor);
        if (descripcion != null) config.setDescripcion(descripcion);

        ConfiguracionSistema guardada = configRepository.save(config);
        log.info("Configuración guardada: {} = {}", clave, valor);
        return guardada;
    }

    @Override
    @Transactional
    public void eliminar(String clave) {
        configRepository.findByClave(clave).ifPresent(c -> {
            configRepository.delete(c);
            log.info("Configuración eliminada: {}", clave);
        });
    }
}

package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "reglamento")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Reglamento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nombreVersion;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String contenido; // Formato Quill Delta (JSON) o HTML

    @Column(nullable = false)
    @Builder.Default
    private LocalDateTime fechaCreacion = LocalDateTime.now();

    @Column(nullable = false)
    private String creadoPor;

    @Column(nullable = false)
    @Builder.Default
    private boolean activo = false;
}

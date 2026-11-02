-- ==========================================================================
-- PostgreSQL · Base de datos
-- Ejecuta:  postgres
-- Conexión: base postgres
-- Origen:   Implementación física > PostgreSQL > Base de datos
-- ==========================================================================

SET client_encoding = 'UTF8';
-- Superusuario
CREATE DATABASE inversiones
  OWNER rol_admin_bd
  ENCODING 'UTF8'
  TEMPLATE template0;

-- ==========================================================================
-- PostgreSQL · Esquema
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Implementación física > PostgreSQL > Base de datos
-- ==========================================================================

SET client_encoding = 'UTF8';
-- DBA, conectado a la base de datos inversiones
SET ROLE rol_admin_bd;

CREATE SCHEMA inversiones AUTHORIZATION rol_admin_bd;
ALTER DATABASE inversiones SET search_path TO inversiones;
DROP SCHEMA public;

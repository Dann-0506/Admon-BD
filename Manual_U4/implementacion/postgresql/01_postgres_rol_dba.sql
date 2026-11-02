-- ==========================================================================
-- PostgreSQL · Rol del DBA
-- Ejecuta:  postgres
-- Conexión: base postgres
-- Origen:   Usuarios y roles > Creación de roles y usuarios en PostgreSQL
-- ==========================================================================

SET client_encoding = 'UTF8';
CREATE ROLE rol_admin_bd NOLOGIN CREATEROLE;
CREATE USER dlandero WITH PASSWORD 'Dlandero#2026' IN ROLE rol_admin_bd;

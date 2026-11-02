-- ==========================================================================
-- PostgreSQL · Datos de prueba (solo primera instancia)
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Implementación física > Datos de prueba
-- ==========================================================================

SET client_encoding = 'UTF8';
-- Ejecutado por dlandero en la base de datos inversiones
INSERT INTO empresa (empresa_rfc, empresa_nombre, empresa_direccion)
VALUES ('IGO150312AB1', 'Inversiones del Golfo, S.A. de C.V.',
        'Av. Independencia 1250, Centro, Veracruz, Ver.');

INSERT INTO sucursal (empresa_rfc, sucursal_nombre, sucursal_ciudad,
                      sucursal_direccion)
VALUES
  ('IGO150312AB1', 'Sucursal Centro', 'Veracruz',
   'Av. Independencia 1250, Veracruz'),
  ('IGO150312AB1', 'Sucursal Costa Verde', 'Boca del Río',
   'Blvd. Manuel Ávila Camacho 3010, Boca del Río'),
  ('IGO150312AB1', 'Sucursal Xalapa Centro', 'Xalapa',
   'Av. Xalapa 455, Xalapa'),
  ('IGO150312AB1', 'Sucursal Córdoba', 'Córdoba',
   'Calle 3 número 210, Córdoba'),
  ('IGO150312AB1', 'Sucursal Orizaba', 'Orizaba',
   'Av. Oriente 6 número 880, Orizaba'),
  ('IGO150312AB1', 'Sucursal Coatzacoalcos', 'Coatzacoalcos',
   'Av. Zaragoza 512, Coatzacoalcos'),
  ('IGO150312AB1', 'Sucursal Poza Rica', 'Poza Rica',
   'Blvd. Adolfo Ruiz Cortines 1401, Poza Rica'),
  ('IGO150312AB1', 'Sucursal Tuxpan', 'Tuxpan',
   'Av. Juárez 37, Tuxpan'),
  ('IGO150312AB1', 'Sucursal Puebla Angelópolis', 'Puebla',
   'Blvd. Atlixcáyotl 5320, Puebla'),
  ('IGO150312AB1', 'Sucursal Ciudad de México Reforma', 'Ciudad de México',
   'Paseo de la Reforma 222, Ciudad de México'),
  ('IGO150312AB1', 'Sucursal Monterrey San Pedro', 'Monterrey',
   'Av. Vasconcelos 150, Monterrey'),
  ('IGO150312AB1', 'Sucursal Guadalajara Providencia', 'Guadalajara',
   'Av. Providencia 2577, Guadalajara'),
  ('IGO150312AB1', 'Sucursal Mérida Norte', 'Mérida',
   'Calle 60 número 299, Mérida'),
  ('IGO150312AB1', 'Sucursal Oaxaca Centro', 'Oaxaca',
   'Av. Juárez 703, Oaxaca'),
  ('IGO150312AB1', 'Sucursal Villahermosa Tabasco 2000', 'Villahermosa',
   'Prol. Paseo Usumacinta 1001, Villahermosa');

INSERT INTO cliente (cliente_rfc, cliente_nombre, cliente_apellido,
                     cliente_direccion, cliente_telefono)
VALUES
  ('HEGJ720604HM3', 'José Luis', 'Hernández García',
   'Calle Hidalgo 100, Veracruz', '2291000000'),
  ('LOMM791107RZ6', 'María Fernanda', 'López Martínez',
   'Calle Morelos 113, Boca del Río', '2291037291'),
  ('RASC860410YL9', 'Carlos', 'Ramírez Sánchez',
   'Calle Allende 126, Xalapa', '2291074582'),
  ('TOGA680913FY2', 'Ana Sofía', 'Torres Gómez',
   'Calle Juárez 139, Córdoba', '2291111873'),
  ('FODJ750216NK5', 'Jorge', 'Flores Díaz',
   'Calle Madero 152, Orizaba', '2291149164'),
  ('MOCL820719WX8', 'Lucía', 'Morales Cruz',
   'Calle Hidalgo 165, Coatzacoalcos', '2291186455'),
  ('REOM891222DJ1', 'Miguel Ángel', 'Reyes Ortiz',
   'Calle Morelos 178, Poza Rica', '2291223746'),
  ('JIRD710525LW4', 'Daniela', 'Jiménez Ruiz',
   'Calle Allende 191, Tuxpan', '2291261037'),
  ('VACR781001UH7', 'Roberto', 'Vázquez Castillo',
   'Calle Juárez 204, Puebla', '2291298328'),
  ('MEAP850304BV0', 'Patricia', 'Mendoza Aguilar',
   'Calle Madero 217, Ciudad de México', '2291335619'),
  ('GURF670807JG3', 'Fernando', 'Gutiérrez Romero',
   'Calle Hidalgo 230, Monterrey', '2291372910'),
  ('CAHG740110SU6', 'Gabriela', 'Castro Herrera',
   'Calle Morelos 243, Guadalajara', '2291410201'),
  ('CAMR810613ZF9', 'Ricardo', 'Chávez Medina',
   'Calle Allende 256, Mérida', '2291447492'),
  ('VARA881116GT2', 'Alejandra', 'Vargas Ríos',
   'Calle Juárez 269, Oaxaca', '2291484783'),
  ('DOPE700419PE5', 'Eduardo', 'Domínguez Peña',
   'Calle Madero 282, Villahermosa', '2291522074'),
  ('SAIV770922XS8', 'Verónica', 'Salazar Ibarra',
   'Calle Hidalgo 295, Veracruz', '2291559365'),
  ('NACA840225ED1', 'Arturo', 'Navarro Cortés',
   'Calle Morelos 308, Boca del Río', '2291596656'),
  ('ROFC660701MR4', 'Claudia', 'Rojas Fuentes',
   'Calle Allende 321, Xalapa', '2291633947'),
  ('GULH731204VC7', 'Héctor', 'Guzmán Luna',
   'Calle Juárez 334, Córdoba', '2291671238'),
  ('EIVM800507CP0', 'Mónica', 'Espinoza Vega',
   'Calle Madero 347, Orizaba', '2291708529'),
  ('SAPF871010KB3', 'Francisco', 'Sandoval Pacheco',
   'Calle Hidalgo 360, Coatzacoalcos', '2291745820'),
  ('CAST690313TN6', 'Teresa', 'Cabrera Soto',
   'Calle Morelos 373, Poza Rica', '2291783111'),
  ('COLR760816AA9', 'Raúl', 'Contreras Lara',
   'Calle Allende 386, Tuxpan', '2291820402'),
  ('MORS830119HM2', 'Silvia', 'Montes Rosales',
   'Calle Juárez 399, Puebla', '2291857693'),
  ('NUVA650622RZ5', 'Andrés', 'Núñez Valdez',
   'Calle Madero 412, Ciudad de México', '2291894984');

INSERT INTO aval (aval_rfc, aval_nombre, aval_apellido, aval_direccion)
VALUES
  ('PEZM630913ED0', 'Manuel', 'Pérez Zamora',
   'Av. Revolución 200, Córdoba'),
  ('DECL700216MR3', 'Laura', 'Delgado Campos',
   'Av. Insurgentes 217, Orizaba'),
  ('AOBE770719VC6', 'Ernesto', 'Acosta Bravo',
   'Av. Constitución 234, Coatzacoalcos'),
  ('POGR591222CP9', 'Rosa María', 'Ponce Galván',
   'Av. Reforma 251, Poza Rica'),
  ('OOTG660525KB2', 'Guillermo', 'Ochoa Trejo',
   'Av. Universidad 268, Tuxpan'),
  ('SOMB731001TN5', 'Beatriz', 'Solís Mejía',
   'Av. Revolución 285, Puebla'),
  ('CAQA800304AA8', 'Alberto', 'Carrillo Quiroz',
   'Av. Insurgentes 302, Ciudad de México'),
  ('BALL620807HM1', 'Leticia', 'Bautista Lozano',
   'Av. Constitución 319, Monterrey'),
  ('MOAO690110RZ4', 'Óscar', 'Molina Arias',
   'Av. Reforma 336, Guadalajara'),
  ('FITE760613YL7', 'Elena', 'Figueroa Tapia',
   'Av. Universidad 353, Mérida'),
  ('VARS581116FY0', 'Sergio', 'Valencia Robles',
   'Av. Revolución 370, Oaxaca'),
  ('EUDA650419NK3', 'Adriana', 'Esquivel Duarte',
   'Av. Insurgentes 387, Villahermosa'),
  ('CEMJ720922WX6', 'Javier', 'Cervantes Mora',
   'Av. Constitución 404, Veracruz'),
  ('BECN790225DJ9', 'Norma', 'Beltrán Cuevas',
   'Av. Reforma 421, Boca del Río'),
  ('AESR610701LW2', 'Rubén', 'Avendaño Silva',
   'Av. Universidad 438, Xalapa');

INSERT INTO inversion (pagare_num, sucursal_num, cliente_num, aval_num,
                       inversion_capital, inversion_tasa,
                       inversion_tasa_moratoria, inversion_dia_pago,
                       pagare_fecha, pagare_jurisdiccion,
                       inversion_fecha_vencimiento)
VALUES
  ('0001/2024',  1,  1,    1,  50000.00, 0.8500, 3.0000, 10,
   '2024-01-01', 'Veracruz', '2024-07-10'),
  ('0002/2024',  2,  2,    2,  75000.00, 0.9500, 2.5000, 19,
   '2024-02-06', 'Boca del Río', '2025-02-19'),
  ('0003/2024',  3,  3, NULL, 100000.00, 1.0500, 3.0000, 28,
   '2024-03-11', 'Xalapa', '2025-09-28'),
  ('0004/2024',  4,  4,    4, 150000.00, 1.1500, 2.5000,  9,
   '2024-04-16', 'Córdoba', '2024-10-09'),
  ('0005/2024',  5,  5,    5, 200000.00, 1.2500, 3.0000, 18,
   '2024-05-21', 'Orizaba', '2025-05-18'),
  ('0006/2024',  6,  6, NULL, 250000.00, 0.8500, 2.5000, 27,
   '2024-06-26', 'Coatzacoalcos', '2025-12-27'),
  ('0008/2024',  7,  7,    7, 300000.00, 0.9500, 3.0000,  8,
   '2024-07-04', 'Poza Rica', '2025-01-08'),
  ('0009/2024',  8,  8,    8, 500000.00, 1.0500, 2.5000, 17,
   '2024-08-09', 'Tuxpan', '2025-08-17'),
  ('0011/2024',  9,  9, NULL,  50000.00, 1.1500, 3.0000, 26,
   '2024-09-14', 'Puebla', '2026-03-26'),
  ('0013/2024', 10, 10,   10,  75000.00, 1.2500, 2.5000,  7,
   '2024-10-19', 'Ciudad de México', '2025-04-07'),
  ('0016/2024', 11, 11,   11, 100000.00, 0.8500, 3.0000, 16,
   '2024-11-24', 'Monterrey', '2025-11-16'),
  ('0017/2024', 12, 12, NULL, 150000.00, 0.9500, 2.5000, 25,
   '2024-12-02', 'Guadalajara', '2026-06-25'),
  ('0001/2025', 13, 13,   13, 200000.00, 1.0500, 3.0000,  6,
   '2025-01-07', 'Mérida', '2025-07-06'),
  ('0003/2025', 14, 14,   14, 250000.00, 1.1500, 2.5000, 15,
   '2025-02-12', 'Oaxaca', '2026-02-15'),
  ('0007/2025', 15, 15, NULL, 300000.00, 1.2500, 3.0000, 24,
   '2025-03-17', 'Villahermosa', '2026-09-24'),
  ('0007/2024',  1, 16,    1, 500000.00, 0.8500, 2.5000,  5,
   '2024-07-02', 'Veracruz', '2025-07-05'),
  ('0010/2024',  2, 17,    2,  50000.00, 0.9500, 3.0000, 14,
   '2024-08-09', 'Boca del Río', '2025-11-14'),
  ('0012/2024',  3, 18, NULL,  75000.00, 1.0500, 2.5000, 23,
   '2024-09-16', 'Xalapa', '2025-09-23'),
  ('0014/2024',  4, 19,    4, 100000.00, 1.1500, 3.0000,  4,
   '2024-10-23', 'Córdoba', '2026-01-04'),
  ('0015/2024',  5, 20,    5, 150000.00, 1.2500, 2.5000, 13,
   '2024-11-03', 'Orizaba', '2025-11-13'),
  ('0018/2024',  6, 21, NULL, 200000.00, 0.8500, 3.0000, 22,
   '2024-12-10', 'Coatzacoalcos', '2026-03-22'),
  ('0002/2025',  7, 22,    7, 250000.00, 0.9500, 2.5000,  3,
   '2025-01-17', 'Poza Rica', '2026-01-03'),
  ('0004/2025',  8, 23,    8, 300000.00, 1.0500, 3.0000, 12,
   '2025-02-24', 'Tuxpan', '2026-05-12'),
  ('0006/2025',  9, 24, NULL, 500000.00, 1.1500, 2.5000, 21,
   '2025-03-04', 'Puebla', '2026-03-21'),
  ('0009/2025', 10, 25,   10,  50000.00, 1.2500, 3.0000,  2,
   '2025-04-11', 'Ciudad de México', '2026-07-02'),
  ('0005/2025', 11,  1,   11,  75000.00, 0.8500, 2.5000, 11,
   '2025-03-01', 'Monterrey', '2027-03-11'),
  ('0008/2025', 12,  2, NULL, 100000.00, 0.9500, 3.0000, 20,
   '2025-04-05', 'Guadalajara', '2027-04-20'),
  ('0010/2025', 13,  3,   13, 150000.00, 1.0500, 2.5000,  1,
   '2025-05-09', 'Mérida', '2027-05-01'),
  ('0011/2025', 14,  4,   14, 200000.00, 1.1500, 3.0000, 10,
   '2025-06-13', 'Oaxaca', '2027-06-10'),
  ('0012/2025', 15,  5, NULL, 250000.00, 1.2500, 2.5000, 19,
   '2025-07-17', 'Villahermosa', '2027-01-19'),
  ('0013/2025',  1,  6,    1, 300000.00, 0.8500, 3.0000, 28,
   '2025-08-21', 'Veracruz', '2027-08-28'),
  ('0014/2025',  2,  7,    2, 500000.00, 0.9500, 2.5000,  9,
   '2025-09-25', 'Boca del Río', '2027-03-09'),
  ('0015/2025',  3,  8, NULL,  50000.00, 1.0500, 3.0000, 18,
   '2025-10-02', 'Xalapa', '2027-10-18'),
  ('0016/2025',  4,  9,    4,  75000.00, 1.1500, 2.5000, 27,
   '2025-11-06', 'Córdoba', '2027-05-27'),
  ('0017/2025',  5, 10,    5, 100000.00, 1.2500, 3.0000,  8,
   '2025-12-10', 'Orizaba', '2027-12-08'),
  ('0001/2026',  6, 11, NULL, 150000.00, 0.8500, 2.5000, 17,
   '2026-01-14', 'Coatzacoalcos', '2027-07-17'),
  ('0002/2026',  7, 12,    7, 200000.00, 0.9500, 3.0000, 26,
   '2026-02-18', 'Poza Rica', '2028-02-26'),
  ('0003/2026',  8, 13,    8, 250000.00, 1.0500, 2.5000,  7,
   '2026-03-22', 'Tuxpan', '2027-09-07'),
  ('0004/2026',  9, 14, NULL, 300000.00, 1.1500, 3.0000, 16,
   '2026-04-26', 'Puebla', '2028-04-16'),
  ('0005/2026', 10, 15,   10, 500000.00, 1.2500, 2.5000, 25,
   '2026-05-03', 'Ciudad de México', '2027-11-25');

-- Tabla de interés de cada inversión
CALL generar_tabla_interes(1);   CALL generar_tabla_interes(2);
CALL generar_tabla_interes(3);   CALL generar_tabla_interes(4);
CALL generar_tabla_interes(5);   CALL generar_tabla_interes(6);
CALL generar_tabla_interes(7);   CALL generar_tabla_interes(8);
CALL generar_tabla_interes(9);   CALL generar_tabla_interes(10);
CALL generar_tabla_interes(11);  CALL generar_tabla_interes(12);
CALL generar_tabla_interes(13);  CALL generar_tabla_interes(14);
CALL generar_tabla_interes(15);  CALL generar_tabla_interes(16);
CALL generar_tabla_interes(17);  CALL generar_tabla_interes(18);
CALL generar_tabla_interes(19);  CALL generar_tabla_interes(20);
CALL generar_tabla_interes(21);  CALL generar_tabla_interes(22);
CALL generar_tabla_interes(23);  CALL generar_tabla_interes(24);
CALL generar_tabla_interes(25);  CALL generar_tabla_interes(26);
CALL generar_tabla_interes(27);  CALL generar_tabla_interes(28);
CALL generar_tabla_interes(29);  CALL generar_tabla_interes(30);
CALL generar_tabla_interes(31);  CALL generar_tabla_interes(32);
CALL generar_tabla_interes(33);  CALL generar_tabla_interes(34);
CALL generar_tabla_interes(35);  CALL generar_tabla_interes(36);
CALL generar_tabla_interes(37);  CALL generar_tabla_interes(38);
CALL generar_tabla_interes(39);  CALL generar_tabla_interes(40);

INSERT INTO liquidacion (inversion_num, liquidacion_fecha,
                         liquidacion_capital, liquidacion_mora)
SELECT inversion_num,
       CASE WHEN inversion_num % 5 = 0
            THEN inversion_fecha_vencimiento + 20
            ELSE inversion_fecha_vencimiento
       END,
       inversion_capital,
       CASE WHEN inversion_num % 5 = 0
            THEN ROUND(inversion_capital * inversion_tasa_moratoria
                       / 100 * 20 / 30, 2)
            ELSE 0
       END
FROM inversion
WHERE inversion_num BETWEEN 1 AND 15;

INSERT INTO pago (inversion_num, interes_fecha_inicial, pago_fecha,
                  pago_interes, pago_mora)
WITH periodo AS (
  SELECT i.inversion_num, i.interes_fecha_inicial,
         i.interes_fecha_final AS fin, i.interes_monto AS monto,
         v.inversion_tasa_moratoria AS tasa_mor,
         (v.inversion_num % 4 = 0 AND
          EXTRACT(MONTH FROM i.interes_fecha_final) IN (3, 6, 9, 12))
           AS tardio,
         (v.inversion_num % 7 = 0 AND
          EXTRACT(MONTH FROM i.interes_fecha_final) = 6) AS parcial
  FROM interes i
    JOIN inversion v ON v.inversion_num = i.inversion_num
  WHERE i.interes_fecha_final <= DATE '2026-10-28'
    AND NOT (v.inversion_fecha_vencimiento < DATE '2026-10-28'
             AND NOT EXISTS (SELECT 1 FROM liquidacion l
                             WHERE l.inversion_num = v.inversion_num)
             AND i.interes_fecha_final >
                 v.inversion_fecha_vencimiento - INTERVAL '2 months')
)
-- Pago completo en la fecha de pago
SELECT inversion_num, interes_fecha_inicial, fin, monto, 0
FROM periodo
WHERE NOT tardio AND NOT parcial
UNION ALL
-- Pago tardío: 10 días de atraso
SELECT inversion_num, interes_fecha_inicial, fin + 10, monto,
       ROUND(monto * tasa_mor / 100 * 10 / 30, 2)
FROM periodo
WHERE tardio
UNION ALL
-- Pago parcial: 60 % en la fecha de pago
SELECT inversion_num, interes_fecha_inicial, fin,
       ROUND(monto * 0.6, 2), 0
FROM periodo
WHERE parcial AND NOT tardio
UNION ALL
-- Resto del pago parcial: 15 días de atraso
SELECT inversion_num, interes_fecha_inicial, fin + 15,
       monto - ROUND(monto * 0.6, 2),
       ROUND((monto - ROUND(monto * 0.6, 2)) * tasa_mor / 100 * 15 / 30, 2)
FROM periodo
WHERE parcial AND NOT tardio;

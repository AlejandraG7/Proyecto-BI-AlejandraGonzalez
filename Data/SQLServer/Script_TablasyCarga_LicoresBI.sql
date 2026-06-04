-- ==========================================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS - MODELO ESTRELLA
-- Proyecto: Fiscalización y Control del Mercado de Licores
-- Motor: SQL Server
-- ==========================================================

CREATE DATABASE BD_LicoresBI;
GO

USE BD_LicoresBI;
GO

-- ==========================================================
-- DIMENSIÓN TIEMPO
-- ==========================================================
CREATE TABLE DimTiempo (
    id_tiempo INT PRIMARY KEY,
    fecha DATE NULL,
    dia INT NULL,
    mes INT NULL,
    nombre_mes NVARCHAR(20) NULL,
    trimestre INT NULL,
    anio INT NULL,
    tipo_fecha NVARCHAR(30) NULL
);
GO

-- ==========================================================
-- DIMENSIÓN MARCA LICOR
-- ==========================================================
CREATE TABLE DimMarcaLicor (
    id_marca INT PRIMARY KEY,
    nombre_marca NVARCHAR(255) NULL,
    numero_registro NVARCHAR(100) NULL,
    estado_registro NVARCHAR(100) NULL
);
GO

-- ==========================================================
-- DIMENSIÓN PROVEEDOR
-- ==========================================================
CREATE TABLE DimProveedor (
    id_proveedor INT PRIMARY KEY,
    proveedor_remitente NVARCHAR(255) NULL,
    credencial_supervisor NVARCHAR(100) NULL
);
GO

-- ==========================================================
-- DIMENSIÓN MAYORISTA
-- ==========================================================
CREATE TABLE DimMayorista (
    id_mayorista INT PRIMARY KEY,
    nombre_mayorista NVARCHAR(255) NULL,
    licencia_mayorista NVARCHAR(100) NULL
);
GO

-- ==========================================================
-- DIMENSIÓN ESTADO REGISTRO
-- ==========================================================
CREATE TABLE DimEstadoRegistro (
    id_estado INT PRIMARY KEY,
    estado_registro NVARCHAR(100) NULL,
    categoria_control NVARCHAR(50) NULL
);
GO

-- ==========================================================
-- TABLA DE HECHOS
-- ==========================================================
CREATE TABLE FactRegistroLicor (
    id_registro INT PRIMARY KEY,
    id_tiempo_inicio INT NULL,
    id_tiempo_vencimiento INT NULL,
    id_marca INT NULL,
    id_proveedor INT NULL,
    id_estado INT NULL,
    dias_vigencia INT NULL,
    dias_para_vencer INT NULL,
    tiene_mayorista BIT NULL,
    cantidad_mayoristas INT NULL,

    CONSTRAINT FK_Fact_DimTiempoInicio
        FOREIGN KEY (id_tiempo_inicio) REFERENCES DimTiempo(id_tiempo),

    CONSTRAINT FK_Fact_DimTiempoVencimiento
        FOREIGN KEY (id_tiempo_vencimiento) REFERENCES DimTiempo(id_tiempo),

    CONSTRAINT FK_Fact_DimMarcaLicor
        FOREIGN KEY (id_marca) REFERENCES DimMarcaLicor(id_marca),

    CONSTRAINT FK_Fact_DimProveedor
        FOREIGN KEY (id_proveedor) REFERENCES DimProveedor(id_proveedor),

    CONSTRAINT FK_Fact_DimEstadoRegistro
        FOREIGN KEY (id_estado) REFERENCES DimEstadoRegistro(id_estado)
);
GO

-- ==========================================================
-- TABLA PUENTE REGISTRO - MAYORISTA
-- ==========================================================
CREATE TABLE BridgeRegistroMayorista (
    id_registro INT NOT NULL,
    id_mayorista INT NOT NULL,

    CONSTRAINT PK_BridgeRegistroMayorista
        PRIMARY KEY (id_registro, id_mayorista),

    CONSTRAINT FK_Bridge_FactRegistroLicor
        FOREIGN KEY (id_registro) REFERENCES FactRegistroLicor(id_registro),

    CONSTRAINT FK_Bridge_DimMayorista
        FOREIGN KEY (id_mayorista) REFERENCES DimMayorista(id_mayorista)
);
GO

-- ==========================================================
-- CARGA DE DATOS DESDE ARCHIVOS CSV
-- Proyecto: Fiscalización y Control del Mercado de Licores
-- Motor: SQL Server
-- ==========================================================

USE BD_LicoresBI;
GO

-- ==========================================================
-- 1. CARGA DIMTIEMPO
-- ==========================================================
BULK INSERT DimTiempo
FROM 'C:\LicoresBI\CSV\DimTiempo.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

-- ==========================================================
-- 2. CARGA DIMMARCA LICOR
-- ==========================================================
BULK INSERT DimMarcaLicor
FROM 'C:\LicoresBI\CSV\DimMarcaLicor.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

-- ==========================================================
-- 3. CARGA DIMPROVEEDOR
-- ==========================================================
BULK INSERT DimProveedor
FROM 'C:\LicoresBI\CSV\DimProveedor.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

-- ==========================================================
-- 4. CARGA DIMMAYORISTA
-- ==========================================================
BULK INSERT DimMayorista
FROM 'C:\LicoresBI\CSV\DimMayorista.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

-- ==========================================================
-- 5. CARGA DIMESTADOREGISTRO
-- ==========================================================
BULK INSERT DimEstadoRegistro
FROM 'C:\LicoresBI\CSV\DimEstadoRegistro.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

-- ==========================================================
-- 6. CARGA FACTREGISTROLICOR
-- ==========================================================
BULK INSERT FactRegistroLicor
FROM 'C:\LicoresBI\CSV\FactRegistroLicor.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

-- ==========================================================
-- 7. CARGA BRIDGEREGISTROMAYORISTA
-- ==========================================================
BULK INSERT BridgeRegistroMayorista
FROM 'C:\LicoresBI\CSV\BridgeRegistroMayorista.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

-- ==========================================================
-- VERIFICACIÓN DE REGISTROS CARGADOS
-- ==========================================================
SELECT 'DimTiempo' AS Tabla, COUNT(*) AS Registros FROM DimTiempo
UNION ALL
SELECT 'DimMarcaLicor', COUNT(*) FROM DimMarcaLicor
UNION ALL
SELECT 'DimProveedor', COUNT(*) FROM DimProveedor
UNION ALL
SELECT 'DimMayorista', COUNT(*) FROM DimMayorista
UNION ALL
SELECT 'DimEstadoRegistro', COUNT(*) FROM DimEstadoRegistro
UNION ALL
SELECT 'FactRegistroLicor', COUNT(*) FROM FactRegistroLicor
UNION ALL
SELECT 'BridgeRegistroMayorista', COUNT(*) FROM BridgeRegistroMayorista;
GO

SELECT TOP 20 * FROM DimMarcaLicor;

SELECT TOP 20 * FROM DimProveedor;

SELECT TOP 20 * FROM DimMayorista;

SELECT TOP 20 * FROM FactRegistroLicor;

SELECT TOP 20 * FROM BridgeRegistroMayorista;

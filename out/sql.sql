CREATE TABLE IF NOT EXISTS "T_M_Datas" (
	"id"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"MMac"	varchar(50) NOT NULL,
	"MSBP"	varchar(20),
	"MDBP"	varchar(20),
	"MHR"	varchar(20),
	"MDate"	datetime DEFAULT (datetime(CURRENT_TIMESTAMP,'localtime'))
);
CREATE TABLE IF NOT EXISTS "T_M_User" (
	"id"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"MMac"	varchar(50) NOT NULL,
	"MUser"	varchar(50),
	"MDesc"	varchar(250)
);
CREATE TABLE IF NOT EXISTS "T_M_Infos" (
	"id"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"MNo"	varchar(50) NOT NULL,
	"MMac"	varchar(50) NOT NULL,
	"MGroup" varchar(50),
	"MDesc"	varchar(250)
);

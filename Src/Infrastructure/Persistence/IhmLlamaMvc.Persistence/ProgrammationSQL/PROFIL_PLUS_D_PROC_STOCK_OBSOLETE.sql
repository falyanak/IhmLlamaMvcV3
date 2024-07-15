IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_D_PROC_STOCK_OBSOLETE')
DROP PROCEDURE PROFIL_PLUS_D_PROC_STOCK_OBSOLETE
GO

IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_I_DEMANDE_CREATION_AGENT_NON_CCRF')
DROP PROCEDURE PROFIL_PLUS_I_DEMANDE_CREATION_AGENT_NON_CCRF
GO

/*   
Auteur: François Alyanakian
Date de création: 31/07/2023
Date de modification: 
-------------------------------------------------------------------------------------------------------
Description : Suppression des procédures stockées obsololètes ou renommées
-------------------------------------------------------------------------------------------------------
*/

/*
GRANT EXECUTE ON PROFIL_PLUS_D_PROC_STOCK_OBSOLOTE TO SELECTEXEC
*/	
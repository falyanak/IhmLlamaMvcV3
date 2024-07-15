IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_I_DEMANDE')
DROP PROCEDURE PROFIL_PLUS_I_DEMANDE
GO

CREATE PROCEDURE dbo.PROFIL_PLUS_I_DEMANDE 
    @ADMINISTRATIONORIGINEIDENT tinyint=NULL,
    @UNITEFONCTIONNELLEIDENT smallint,
    @AGENTIDENT smallint=NULL,
    @AGENTCREATEURIDENT smallint,
    @TYPEDEMANDEIDENT tinyint=NULL,
    @UNITEADMINISTRATIVEIDENT smallint, 
    @TYPETRAITEMENTDEMANDEIDENT tinyint,
    @FONCTIONIDENT smallint, 
    @ORIGINEAGENTIDENT tinyint=NULL,
    @NOMFAMILLE varchar(40),
    @PRENOMUSUEL varchar(30),
    @COURRIEL varchar(100),
    @COMMENTAIRE varchar(80),
    @DATEDERNIERCLICBOUTONCOURRIELTEST datetime,
    @COMPTEAD varchar(15),
    @SEXE char(1),
    @LIBSEXE VARCHAR(3)
AS

/*   
Auteur: François Alyanakian
Date de création: 28/11/2022
-------------------------------------------------------------------------------------------------------
Description : Insère une demande de création d'un compte pour un agent non CCRF
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------
*/
BEGIN TRY


-- début du traitement procédure
DECLARE @demande_ident uniqueidentifier = NEWID();
--SELECT @demande_ident as 'GUID';

declare @date_creation datetime = getdate();  -- date et heure dd Mon yyyy hh:mm:ss:nnn : 30 Dec 2006 00:38:54:840

-- insertion dans la table Demande
INSERT PROFIL_PLUS_Demande
           (
           PFL_PLUS_DemandeIdent
           ,AdmOrigineIdent
           ,Unfct_Ident
           ,Ag_Ident_Createur
           ,Ag_Ident_ConcerneParDemande
           ,TypeDemandeIdent
           ,Fct_Unfct_Ident
           ,TypeTraitementDemandeIdent
           ,FCT_IDENT
           ,ORIAG_IDENT
           ,PFL_PLUS_NomFam
           ,PFL_PLUS_PreUsu
           ,PFL_PLUS_Sexe
           ,PFL_PLUS_LibelleSexe
           ,PFL_PLUS_Mail
           ,PFL_PLUS_CompteAD
           ,PFL_PLUS_Commentaire
           ,PFL_PLUS_DateCreationDemande
           ,PFL_PLUS_DateEnvoiMail
           ,PFL_PLUS_DemandeObsolet
           ,PFL_PLUS_CompteADCree
           ,PFL_PLUS_CompteApplicatifCree
           ,PFL_PLUS_DateDernierClicBoutonCourrielTest
           )
     VALUES
           (
           @demande_ident,
           @ADMINISTRATIONORIGINEIDENT,
           @UNITEFONCTIONNELLEIDENT,
           @AGENTCREATEURIDENT,
           @AGENTIDENT,
           @TYPEDEMANDEIDENT,
           @UNITEADMINISTRATIVEIDENT, 
           @TYPETRAITEMENTDEMANDEIDENT,
           @FONCTIONIDENT , 
           @ORIGINEAGENTIDENT,
           @NOMFAMILLE,
           @PRENOMUSUEL,
           @SEXE,
           @LIBSEXE,
           @COURRIEL,
           @COMPTEAD,
           @COMMENTAIRE,
           @date_creation,
           @date_creation,
           0,
           0,
           0,
           @DATEDERNIERCLICBOUTONCOURRIELTEST
           )
 
  -- Renvoi de l'identifiant Guid et dela date de création
   SELECT @demande_ident AS 'Id', @date_creation AS 'DateCreationDemande';

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
       ROLLBACK TRANSACTION

       DECLARE @NomProcedure VARCHAR(255),@NomBase VARCHAR(255)
       SELECT @NomProcedure =OBJECT_NAME(@@PROCID), @NomBase=DB_NAME()
       EXEC TraceSQL.dbo.P_SQLAPP_I_TraceErreurs @NomProcedure,@NomBase

       -- Propage l'erreur au niveau supérieur
       DECLARE @ERROR_MESSAGE NVARCHAR(4000),@ERROR_NUMBER INT,@ERROR_SEVERITY INT,@ERROR_STATE INT
       SET @ERROR_MESSAGE=ERROR_MESSAGE()
       SET @ERROR_SEVERITY=ERROR_SEVERITY()
       SET @ERROR_STATE=ERROR_STATE()
       RAISERROR(@ERROR_MESSAGE,@ERROR_SEVERITY,@ERROR_STATE)

END CATCH;

GO
/*
GRANT EXECUTE ON PROFIL_PLUS_I_DEMANDE TO SELECTEXEC
*/
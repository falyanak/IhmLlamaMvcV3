IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_I_COMPTES_INACTIFS')
DROP PROCEDURE PROFIL_PLUS_I_COMPTES_INACTIFS
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_I_COMPTES_INACTIFS]
@CompteAd varchar(15),
@DateDerniereConnexionAD datetime,
@Mail varchar(100),
@DistinguishedName varchar(300),
@DateEnvoiCourrielInitial datetime,
@DateEnvoiCourrielRelance datetime,
@DateMaintienActivite datetime,
@DateEnvoiCourrielSuppression datetime,
@DateSuppressionAD datetime,
@EtatGestionIdent tinyint,
@Entite varchar(5)
AS
/*   
Auteur: François Alyanakian
Date de création: 18/10/2023
-------------------------------------------------------------------------------------------------------
Description : Création d'un compte Windows inactif à désactiver automatiquement
              si l'agent n'en a pas demandé le maintien en cliquant sur un lien présent
              dans un courriel
-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY
-- début du traitement procédure
DECLARE @gestion_ident uniqueidentifier = NEWID();

  INSERT INTO PROFIL_PLUS_Gestion_Compte_Inactif
           (
            PFL_PLUS_Gestion_Ident
           ,PFL_PLUS_CompteADInactif
           ,PFL_PLUS_DistinguishedName
           ,PFL_PLUS_DateDerniereConnexionAD
           ,PFL_PLUS_Mail
           ,PFL_PLUS_DateEnvoiCourrielInitial
           ,PFL_PLUS_DateEnvoiCourrielRelance
           ,PFL_PLUS_DateMaintienActivite
           ,PFL_PLUS_DateEnvoiCourrielSuppression
           ,PFL_PLUS_DateSuppressionAD
           ,PFL_PLUS_EtatGestionIdent
           ,PFL_PLUS_Entite)
     VALUES
           (
            @gestion_ident
           ,@CompteAd
           ,@DistinguishedName
           ,@DateDerniereConnexionAD
           ,@Mail
           ,@DateEnvoiCourrielInitial
           ,@DateEnvoiCourrielRelance
           ,@DateMaintienActivite
           ,@DateEnvoiCourrielSuppression
           ,@DateSuppressionAD
           ,@EtatGestionIdent
           ,@Entite)
 
  -- Renvoi de l'identifiant Guid
   SELECT @gestion_ident AS 'Id';


END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0
	ROLLBACK TRANSACTION;
        
    DECLARE @NomProcedure VARCHAR(255),@NomBase  VARCHAR(255);
    SELECT @NomProcedure =OBJECT_NAME(@@PROCID), @NomBase=DB_NAME();
    EXEC TraceSQL.dbo.P_SQLAPP_I_TraceErreurs @NomProcedure,@NomBase;

            -- Propage l'erreur au niveau supérieur
    DECLARE @ERROR_MESSAGE NVARCHAR(4000),@ERROR_NUMBER INT,@ERROR_SEVERITY INT,@ERROR_STATE INT;
    SET  @ERROR_MESSAGE=ERROR_MESSAGE();
    SET  @ERROR_SEVERITY=ERROR_SEVERITY();
    SET  @ERROR_STATE=ERROR_STATE();
    RAISERROR(@ERROR_MESSAGE,@ERROR_SEVERITY,@ERROR_STATE);

END CATCH;

GO
/*
GRANT EXECUTE ON PROFIL_PLUS_I_COMPTES_INACTIFS TO SELECTEXEC
*/

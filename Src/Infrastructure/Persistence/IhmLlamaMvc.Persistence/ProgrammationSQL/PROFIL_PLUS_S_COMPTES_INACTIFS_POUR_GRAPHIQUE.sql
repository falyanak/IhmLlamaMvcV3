IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_S_COMPTES_INACTIFS_POUR_GRAPHIQUE')
DROP PROCEDURE PROFIL_PLUS_S_COMPTES_INACTIFS_POUR_GRAPHIQUE
GO

CREATE PROCEDURE [dbo].[PROFIL_PLUS_S_COMPTES_INACTIFS_POUR_GRAPHIQUE]
(
  @DateDebut datetime,
  @DateFin datetime,
  @Entite varchar(10)=NULL
)
AS
/*   
Auteur: François Alyanakian
Date de création: 15/12/2023
-------------------------------------------------------------------------------------------------------
Description : Retourne la liste des comptes Windows inactifs à désactiver automatiquement
              si l'agent n'en a pas demandé le maintien en cliquant sur un lien présent
              dans un courriel
-------------------------------------------------------------------------------------------------------
*/

BEGIN TRY

IF @Entite IS NOT NULL AND (RIGHT(@Entite,1)='*' OR LEFT(@Entite,1)='*')
       SET @Entite = REPLACE(@Entite,'*','%')  

   SELECT PFL_PLUS_Gestion_Ident as 'Id'
      ,PFL_PLUS_CompteADInactif as 'CompteAd'
      ,PFL_PLUS_DistinguishedName as 'DistinguishedName'
      ,PFL_PLUS_DateDerniereConnexionAD as 'DateDerniereConnexionAD'
      ,PFL_PLUS_Mail as 'Mail'
      ,PFL_PLUS_DateEnvoiCourrielInitial as 'DateEnvoiCourrielInitial'
      ,PFL_PLUS_DateEnvoiCourrielRelance as 'DateEnvoiCourrielRelance'
      ,PFL_PLUS_DateMaintienActivite as 'DateMaintienActivite'
      ,PFL_PLUS_DateEnvoiCourrielSuppression as 'DateEnvoiCourrielSuppression'
      ,PFL_PLUS_DateSuppressionAD as 'DateSuppressionAD'
      ,PFL_PLUS_Entite as 'Entite'
      ,PFL_PLUS_EtatGestionIdent as 'EtatGestionId'
      ,Etat.EtatGestionLibelle as 'EtatGestion'

  FROM PROFIL_PLUS_Gestion_Compte_Inactif AS Compte
  INNER JOIN PROFIL_PLUS_REF_EtatGestionCompteInactif AS Etat
  ON Compte.PFL_PLUS_EtatGestionIdent = Etat.EtatGestionIdent

  WHERE  
  PFL_PLUS_Entite LIKE CASE WHEN @Entite IS NOT NULL THEN @Entite ELSE '%' END AND 
  (PFL_PLUS_DateEnvoiCourrielInitial >= @DateDebut AND PFL_PLUS_DateEnvoiCourrielInitial <= @DateFin OR
  PFL_PLUS_DateEnvoiCourrielRelance >= @DateDebut AND PFL_PLUS_DateEnvoiCourrielRelance <= @DateFin OR
  PFL_PLUS_DateMaintienActivite >= @DateDebut AND PFL_PLUS_DateMaintienActivite <= @DateFin OR
  PFL_PLUS_DateSuppressionAD >= @DateDebut AND PFL_PLUS_DateSuppressionAD <= @DateFin)


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
GRANT EXECUTE ON PROFIL_PLUS_S_COMPTES_INACTIFS_POUR_GRAPHIQUE TO SELECTEXEC
*/

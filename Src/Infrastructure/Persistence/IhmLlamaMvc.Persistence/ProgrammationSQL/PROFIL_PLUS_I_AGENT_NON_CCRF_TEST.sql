IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_I_AGENT_NON_CCRF_TEST')
DROP PROCEDURE PROFIL_PLUS_I_AGENT_NON_CCRF_TEST
GO


CREATE PROCEDURE [dbo].[PROFIL_PLUS_I_AGENT_NON_CCRF_TEST]
@NOM varchar(40),
@PRENOM varchar(40),
@UNFCTIDENT smallint,
@FCTUNFCTIDENT smallint, 
@COMMENTAIRE varchar(80)=null, 
@COMPTEAD varchar(15)=null, 
@MAIL varchar(100)=null,
@FONCTIONID smallint,
@SEXE char(1),
@LIBSEXE varchar(3)
AS

-- les variables suivants sont des paramètres en entrée 
-- de la procédure d'insertion d'un agent_npc_sirhius 
/*   
Auteur: François Alyanakian
Date de création: 4/01/2023
Date de modification:
-------------------------------------------------------------------------------------------------------
Description : Insertion d'un agent NON CCRF en environnement de DEV et TEST
-------------------------------------------------------------------------------------------------------
Modification :  11/01/2024
                ajout champ sexe
-------------------------------------------------------------------------------------------------------		
*/
BEGIN TRY


-- début du traitement procédure
declare @matrc12 char(12),  @ag_ident smallint, @MatrcSuivant int --@FctUnfctIdent smallint

-- recherche affectation administrative
--select @FctUnfctIdent = CASE 
--       WHEN (select TUNFCT_IDENT from UNITE_FONCTIONNELLE where UNFCT_IDENT = @UNFCTIDENT) in (17,13,15,14,16,20) THEN 176 -- administration centrale
--       WHEN (select TUNFCT_IDENT from UNITE_FONCTIONNELLE where UNFCT_IDENT = @UNFCTIDENT) = 6 OR @UNFCTIDENT = 371 THEN 352 -- scl
--       ELSE @UNFCTIDENT END

-- intégration de l'agent npc sirhius
--select @ag_ident = max(ag_ident)  from INTERFACE_SIRHIUS..W_TRANS_AGENT_DGCCRF_SIRHIUS
select @ag_ident = max(ag_ident)  from REFERENTIEL..AGENT_DGCCRF
select @MatrcSuivant = CAST(replace(max(matrc12),'A','0') as int) from INTERFACE_SIRHIUS..W_TRANS_AGENT_DGCCRF_SIRHIUS where matrc12 like 'A00%'

select   @ag_ident = @ag_ident + 1, 
              @MatrcSuivant = @MatrcSuivant + 1, 
              @matrc12 = CASE WHEN LEN(@MatrcSuivant) = 6 THEN CONCAT('A00000',@MatrcSuivant)
                                      WHEN LEN(@MatrcSuivant) = 7 THEN CONCAT('A0000',@MatrcSuivant)     END  -- Pseudo Matricule




--INSERT INTERFACE_SIRHIUS..W_TRANS_AGENT_DGCCRF_SIRHIUS ([ag_ident],  [matrc12])  VALUES (@ag_ident,  @matrc12)

--INSERT INTERFACE_SIRHIUS..AGENT_NPC_SIRHIUS (ag_ident, matrc12, nomfam, preusu, dtnumreaff,  unfct_ident, fct_unfct_ident,  dtcdrpos, cdrpos,  commentaire,flag_rgpp,flag_agica)
--       VALUES (@ag_ident,@matrc12,@NOM, @PRENOM, convert(char(10),getdate(),103),  @UNFCTIDENT, @FCTUNFCTIDENT, convert(char(10),getdate(),103), 'ACI01', @COMMENTAIRE,1,0)

--INSERT synchro.dbo.LISTE_ROUGE_ANAIS VALUES (REPLACE (@COMPTEAD,'-scl','-ccrf'))

INSERT AGENT_DGCCRF (ag_ident, matrc, matrc12, nomfam, preusu, dtnumreaff,  unfct_ident, 
fct_unfct_ident,  dtcdrpos, cdrpos, librpos, ag_flag_obsolet, loginLdap, compteAD, mail, nomPat, cdetcv, libetcv)
 VALUES (@ag_ident,NULL,@matrc12,@NOM, @PRENOM, convert(char(10),getdate(),103),  @UNFCTIDENT, 
 @FCTUNFCTIDENT,convert(char(10),getdate(),103), 'ACI01', 
 'AFFECTE DANS UNE ADMINISTRATION', 0, @COMPTEAD, @COMPTEAD, @MAIL, 'PROFIL+', @SEXE, @LIBSEXE)

 INSERT INTO REF_X_AG_FCT (AG_IDENT, FCT_IDENT)
     VALUES (@ag_ident, @FONCTIONID)

  -- Renvoi de l'identifiant de l'agent
  SELECT @ag_ident AS 'Id';

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
GRANT EXECUTE ON PROFIL_PLUS_I_AGENT_NON_CCRF_TEST TO SELECTEXEC
*/
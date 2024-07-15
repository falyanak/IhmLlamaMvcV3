IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='PROFIL_PLUS_U_AGENT_NON_CCRF')
DROP PROCEDURE PROFIL_PLUS_U_AGENT_NON_CCRF
GO


CREATE PROCEDURE [dbo].PROFIL_PLUS_U_AGENT_NON_CCRF (
    @AGENTIDENT smallint,
    @NOM varchar(40),
    @PRENOM varchar(40),
    @UNFCTIDENT smallint,
    @FCTUNFCTIDENT smallint, 
    @COMMENTAIRE varchar(80)=null, 
    @COMPTEAD varchar(15),
    @MAIL varchar(100),
    @FONCTIONID smallint,
    @SEXE char(1),
    @LIBSEXE varchar(3)
)
AS
/*   
Auteur: François Alyanakian
Date de création: 4/01/2023
-------------------------------------------------------------------------------------------------------
Description : Mise à jour des informations d'un agent non CCRF
-------------------------------------------------------------------------------------------------------
Modification le 1/08/2023 pour créer ou mettre à jour la fonction le cas échéant
             le 11/01/2024 ajout champ sexe
-------------------------------------------------------------------------------------------------------		
*/

BEGIN TRY

declare @fonctionAgent smallint

SET NOCOUNT ON

BEGIN

UPDATE AGENT_DGCCRF 
       set nomfam = @NOM,
           preusu = @PRENOM,
           unfct_ident = @UNFCTIDENT,
           fct_unfct_ident=@FCTUNFCTIDENT,
           loginLdap = @COMPTEAD,
           compteAD = @COMPTEAD,
           mail = @MAIL,
           cdetcv = @SEXE,
           libetcv = @LIBSEXE

       where ag_ident=@AGENTIDENT

    -- rechercher une fonction associée à l'agent
    SELECT @fonctionAgent = FCT_IDENT FROM REF_X_AG_FCT WHERE AG_IDENT = @AGENTIDENT

    -- la fonction n'existe pas dans REF_X_AG_FCT, on la crée
    IF @fonctionAgent IS NULL
    BEGIN
        INSERT INTO REF_X_AG_FCT (AG_IDENT, FCT_IDENT) VALUES (@AGENTIDENT, @FONCTIONID)
    END
    ELSE
    -- la fonction existe et son Id est différent, on la met à jour
        IF @fonctionAgent != @FONCTIONID
    BEGIN
        UPDATE REF_X_AG_FCT SET FCT_IDENT = @FONCTIONID  WHERE AG_IDENT = @AGENTIDENT
    END

END

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
GRANT EXECUTE ON PROFIL_PLUS_U_AGENT_NON_CCRF TO SELECTEXEC
*/

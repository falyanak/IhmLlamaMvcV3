namespace IhmLlamaMvc.Domain.Constants
{
    public static class Constantes
    {
        //"ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÌÍÎÏìíîïÙÚÛÜùúûüÿÑñÇç"
        // modèle de saisie des nom et prénom contrôlée par une expression régulière 
        public const string IdentiteCaracteresAutorises = @"^[a-zA-Z\s'\-éèêëÉÈÊËïîÏÎôÔÇç]+$";

        // modèle de saisie du mail contrôlée par une expression régulière 
        public const string CourrielCaracteresAutorises =
            @"^([a-z,A-Z,1-9,-]+)(\.)([a-z,A-Z,1-9,-]+)@\w+([-.]\w+)*\.gouv.fr$";
    }
}
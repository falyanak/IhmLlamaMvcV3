using System.Runtime.Serialization;

namespace IhmLlamaMvc.CacheManager.Exceptions;

/// <summary>
/// Permet de gerer les exceptions générées par le cache dans la couche infrastructure
/// </summary>
[Serializable]
public class CacheException : Exception
{
    /// <summary>
    /// Conctructeur par defaut
    /// </summary>
    public CacheException()
        : base()
    {
    }

    /// <summary>
    /// Constructeur avec 1 parametre
    /// </summary>
    /// <param name="message">Message à générer dans l'exeption</param>
    public CacheException(string message)
        : base(message)
    {
    }

    /// <summary>
    /// Constructeur avec 2 parametres
    /// </summary>
    /// <param name="message">Message à générer dans l'exeption</param>
    /// <param name="innerException">Exception de base levée</param>
    public CacheException(string message, Exception innerException)
        : base(message, innerException)
    {
    }
    /// <summary>
    /// Constructeur avec 2 parametres
    /// </summary>
    /// <param name="info">Contiens les informations necessaire pour la serialization / deserialization</param>
    /// <param name="context">Decris les information sur le stream (source, destination etc...)</param>
    protected CacheException(SerializationInfo info, StreamingContext context)
        : base(info, context)
    {
    }
}
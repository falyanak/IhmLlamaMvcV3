using System.Runtime.Serialization;

namespace IhmLlamaMvc.Persistence.Exceptions;

/// <summary>
/// Permet de gerer les exceptions générées par la persistence dans la couche Infrastructure
/// </summary>
[Serializable]
public class DataAccessException : Exception
{
    /// <summary>
    /// Conctructeur par defaut
    /// </summary>
    public DataAccessException()
        : base()
    {
    }

    /// <summary>
    /// Constructeur avec 1 parametre
    /// </summary>
    /// <param name="message">Message à générer dans l'exeption</param>
    public DataAccessException(string message)
        : base(message)
    {
    }

    /// <summary>
    /// Constructeur avec 2 parametres
    /// </summary>
    /// <param name="message">Message à générer dans l'exeption</param>
    /// <param name="innerException">Exception de base levée</param>
    public DataAccessException(string message, Exception innerException)
        : base(message, innerException)
    {
    }
    /// <summary>
    /// Constructeur avec 2 parametres
    /// </summary>
    /// <param name="info">Contiens les informations necessaire pour la serialization / deserialization</param>
    /// <param name="context">Decris les information sur le stream (source, destination etc...)</param>
    protected DataAccessException(SerializationInfo info, StreamingContext context)
        : base(info, context)
    {
    }
}
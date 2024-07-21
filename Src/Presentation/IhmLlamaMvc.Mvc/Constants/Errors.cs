using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Mvc.Constants;

/// <summary>
/// Contains the API errors.
/// </summary>
internal static class Errors
{
    /// <summary>
    /// Gets the un-processable request error.
    /// </summary>
    internal static Error UnProcessableRequest => new Error(
        "API.UnProcessableRequest",
        "Le serveur ne peut traiter la requête.");

    /// <summary>
    /// Gets the server error error.
    /// </summary>
    internal static Error ServerError => new Error("API.ServerError", "Le serveur a rencontré une erreur irrécupérable.");
}
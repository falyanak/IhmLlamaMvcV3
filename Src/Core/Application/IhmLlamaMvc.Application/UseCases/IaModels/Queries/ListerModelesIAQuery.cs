using IhmLlamaMvc.Domain.Entites.IaModels;
using IhmLlamaMvc.SharedKernel.Primitives.Result;
using MediatR;

namespace IhmLlamaMvc.Application.UseCases.IaModels.Queries;

/// <summary>
/// Obtenir la recherche des fonctions.
/// </summary>
public sealed class ListerModelesIAQuery : IRequest<Result<IReadOnlyList<ModeleIA>>>
{
}
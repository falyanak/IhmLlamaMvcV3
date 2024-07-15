using System.Runtime.Serialization;
using FluentValidation.Results;
using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Application.Exceptions;

[Serializable]
public sealed class ValidationException : Exception
{
    /// <summary>
    /// Initializes a new instance of the <see cref="ValidationException"/> class.
    /// </summary>
    /// <param name="failures">The collection of validation failures.</param>
    public ValidationException(IEnumerable<ValidationFailure> failures)
        : base("Une ou plusieurs erreurs de validation ont été générées.") =>
        Errors = failures
            .Distinct()
            .Select(failure => new Error(failure.ErrorCode, failure.ErrorMessage))
            .ToArray();

    /// <summary>
    /// Gets the errors.
    /// </summary>
    public IReadOnlyCollection<Error> Errors { get; }

    public override void GetObjectData(SerializationInfo info, StreamingContext context)
    {
        base.GetObjectData(info, context);

        info.AddValue(nameof(Errors), Errors, typeof(IReadOnlyCollection<Error>));
    }
}
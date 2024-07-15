using MediatR;

namespace IhmLlamaMvc.SharedKernel.Primitives;

public abstract class DomainEventBase : INotification
{
    public DateTime EventDate { get; protected set; } = DateTime.UtcNow;
}
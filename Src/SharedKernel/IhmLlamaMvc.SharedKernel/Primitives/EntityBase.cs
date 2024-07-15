namespace IhmLlamaMvc.SharedKernel.Primitives;

/// <summary>
/// Represents the base class that all entities derive from.
/// </summary>
// This can be modified to EntityBase<TId> to support multiple key types (e.g. Guid)
public abstract class EntityBase<TId>
{
    public TId? Id { get; set; }

    private readonly List<DomainEventBase> _domainEvents = new();

    public IEnumerable<DomainEventBase> DomainEvents => _domainEvents.AsReadOnly();

    protected void RegisterDomainEvent(DomainEventBase domainEvent) => _domainEvents.Add(domainEvent);
    internal void ClearDomainEvents() => _domainEvents.Clear();
}
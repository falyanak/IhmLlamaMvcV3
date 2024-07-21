using System.ComponentModel.DataAnnotations;

namespace IhmLlamaMvc.CacheManager.Models;

public class CacheStatistic
{
    public string? key { get; set; }
    public DateTime initTimeRead { get; set; }
    public DateTime lastTimeRead { get; set; }

    [DisplayFormat(DataFormatString = "{0:N0}")]
    public long readDbSpeed { get; set; }

    [DisplayFormat(DataFormatString = "{0:N0}")]
    public long readCacheSpeed { get; set; }

    [DisplayFormat(DataFormatString = "{0:N0}")]
    public long recordsCount { get; set; }

    [DisplayFormat(DataFormatString = "{0:N0}")]
    public long readDbCount { get; set; }

    [DisplayFormat(DataFormatString = "{0:N0}")]
    public long readCacheCount { get; set; }

    [DisplayFormat(DataFormatString = "{0:N0}")]
    public long sizeInCharacters { get; set; }
}
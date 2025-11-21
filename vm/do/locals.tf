locals {
  # Mutual exclusivity check. This creates a clear error if both are set.
  assert_mutually_exclusive = (
    var.slug != null && var.size != null ?
    tobool("Error: The 'size' and 'slug' variables are mutually exclusive and cannot be set at the same time.") :
    true
  )

  # Map to convert a friendly size to a DigitalOcean slug
  size_to_slug = {
    tiny   = "s-1vcpu-1gb"
    small  = "s-1vcpu-2gb"
    medium = "s-2vcpu-4gb"
    large  = "s-4vcpu-8gb"
  }

  # Logic for final_slug:
  #   1. If slug is provided, use it.
  #   2. Else, if size is provided, look up the slug.
  #   3. Else (both are null), use the default 'small' size.
  final_slug = (
    var.slug != null ? var.slug : (
      var.size != null ? local.size_to_slug[var.size] : local.size_to_slug["small"]
    )
  )
}
# Return the API key for Anthropic Claude from an environment variable
ANTHROPIC_API_KEY=...
ENABLE_API_KEY=true

if [ "$ENABLE_API_KEY" = true ]; then
  echo $ANTHROPIC_API_KEY
else
  echo ""
fi

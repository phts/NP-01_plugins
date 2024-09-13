const DEFAULT_CHUNK_SIZE = 20;

async function fetchByChunks(
  api,
  method,
  {args = []},
  {getItems = (d) => d.body || [], chunkSize = DEFAULT_CHUNK_SIZE}
) {
  if (!args.length) {
    throw new Error('Method should have at least one argument as array to split it by chunks');
  }

  const [firstArg, ...restArgs] = args;
  const chunks = Array.from(new Array(Math.ceil(firstArg.length / chunkSize))).map((_, i) =>
    firstArg.slice(i * chunkSize, (i + 1) * chunkSize)
  );

  const output = [];
  for (const chunk of chunks) {
    const data = await api[method](chunk, ...restArgs);
    const items = getItems(data);
    output.push(...items);
  }

  return output;
}

module.exports.fetchByChunks = fetchByChunks;

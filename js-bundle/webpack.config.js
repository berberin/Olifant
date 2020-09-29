module.exports = {
  entry: './scripts/run.js',
  output: {
    // path: './dist',
    filename: 'main.js',
    umdNamedDefine: true,
    libraryTarget: 'var',
    library: 'contract'
  }
};

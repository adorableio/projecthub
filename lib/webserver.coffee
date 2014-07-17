
http      = require('http')
express   = require('express')
path      = require('path')
favicon   = require('serve-favicon')
fs        = require('fs')
yaml      = require('js-yaml')
basicAuth = require('basic-auth-connect')

# Function to load files from our data folder
getDataFile = (file) ->
  try
    filepath = path.join(basePath, 'data', file)
    doc = yaml.safeLoad(fs.readFileSync(filepath, 'utf8'))
  catch err
    console.log(err)

# Express server!
app           = express()
webserver     = http.createServer(app)
basePath      = path.dirname(require.main.filename)
generatedPath = path.join(basePath, '.generated')
vendorPath    = path.join(basePath, 'bower_components')
faviconPath   = path.join(basePath, 'app', 'favicon.ico')

# Get our data file
config  = getDataFile('config.yaml')

# Use Basic Auth?
if config.username? || config.password?
  app.use(basicAuth(config.username, config.password)) if process.env.DYNO?

# Express configuration
app.engine('.html', require('hbs').__express)
app.use(favicon(faviconPath))
app.use('/assets', express.static(generatedPath))
app.use('/vendor', express.static(vendorPath))

# Port configuration
port = process.env.PORT || 3002
webserver.listen(port)

# Routes
app.get '/', (req, res) ->
  # Sort updates by date
  config.updates = config.updates.sort (a, b) ->
    aStr = a.date.toLowerCase()
    bStr = b.date.toLowerCase()
    if (aStr < bStr)
      return 1
    else if (bStr < aStr)
      return -1
    else
      return 0
  res.render(generatedPath + '/index.html', {data: config})


module.exports = webserver

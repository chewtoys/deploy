module.exports = function (config, appRequire) {
  const _ = appRequire('lodash')
  const secrets = appRequire('docker-secret').secrets
  const lang = process.env.LANG
  const appHost = 'app_' + lang
  _.merge(config, {
    env: 'production',
    servePublic: false,
    serveStore: false,
    lang: lang,
    notifier: process.env.NOTIFIER === 'true',
    admin: {
      email: 'support@pastvu.com'
    },
    listen: {
      port: 3000 // Application app.js will listen this port
    },
    uploader: {
      hostname: 'uploader',
      port: 3001
    },
    downloader: {
      hostname: 'downloader',
      port: 3002
    },
    client: {
      protocol: process.env.PROTOCOL,
      hostname: process.env.DOMAIN,
      port: '' // participate in public link generation
    },
    core: {
      hostname: appHost,
      port: 3010
    },
    api: {
      hostname: appHost,
      port: 3011
    },
    storePath: '/store',
    sitemapPath: '/sitemap',
    sitemapGenerateOnStart: true,
    logPath: '/logs',
    serveLogAuth: {
      user: 'admin',
      pass: secrets.pastvu_log_pass
    },
    mongo: {
      connection: 'mongodb://mongo:27017/pastvu',
      pool: 10,
      poolDownloader: 2
    },
    mongo_api: {
      con: 'mongodb://mongo:27017/pastvu'
    },
    redis: {
      host: 'redis'
    },
    mail: {
      type: 'SMTP',
      host: secrets.pastvu_smtp_host,
      port: 25,
      auth: {
        user: secrets.pastvu_smtp_user,
        pass: secrets.pastvu_smtp_pass
      }
    },
    publicApiKeys: {
      yandexMaps: secrets.pastvu_yandex_api_key,
      googleMaps: secrets.pastvu_google_api_key
    }
  })
  return config
}

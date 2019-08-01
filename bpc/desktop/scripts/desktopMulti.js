module.exports = async function(context, commands) {
  await commands.measure.start('https://bangordailynews.com');
  await commands.measure.start('https://bangordailynews.com/browse/arts-culture/');
  return commands.measure.start(
    'https://bangordailynews.com/bdn-maine/?ref=well'
  );
};

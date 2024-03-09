import { EventEmitter } from './events';

describe('EventEmitter', () => {
  let eventEmitter;
  let listener;

  beforeEach(() => {
    eventEmitter = new EventEmitter();
    listener = jest.fn();
  });

  test('on', () => {
    eventEmitter.on('test', listener);
    expect(eventEmitter.listeners['test']).toContain(listener);
  });

  test('off', () => {
    eventEmitter.on('test', listener);
    eventEmitter.off('test', listener);
    expect(eventEmitter.listeners['test']).not.toContain(listener);
  });

  test('off with no listeners', () => {
    expect(() => {
      eventEmitter.off('test', listener);
    }).toThrowError(`There is no listeners for "test"`);
  });

  test('emit', () => {
    eventEmitter.on('test', listener);
    eventEmitter.emit('test', 'param1', 'param2');
    expect(listener).toHaveBeenCalledWith('param1', 'param2');
  });

  test('emit with no listeners', () => {
    eventEmitter.emit('test', 'param1', 'param2');
    expect(listener).not.toHaveBeenCalled();
  });

  test('clear', () => {
    eventEmitter.on('test', listener);
    eventEmitter.clear();
    expect(eventEmitter.listeners).toEqual({});
  });
});

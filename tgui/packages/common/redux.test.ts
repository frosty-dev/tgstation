import {
  Action,
  Reducer,
  applyMiddleware,
  combineReducers,
  createAction,
  createStore,
} from './redux';

// Dummy Reducer
const counterReducer: Reducer<number, Action<string>> = (state = 0, action) => {
  switch (action.type) {
    case 'INCREMENT':
      return state + 1;
    case 'DECREMENT':
      return state - 1;
    default:
      return state;
  }
};

// Dummy Middleware
const loggingMiddleware = (storeApi) => (next) => (action) => {
  console.log('Middleware:', action);
  return next(action);
};

// Dummy Action Creators
const increment = createAction('INCREMENT');
const decrement = createAction('DECREMENT');

describe('Redux implementation tests', () => {
  test('createStore works', () => {
    const store = createStore(counterReducer);
    expect(store.getState()).toBe(0);
  });

  test('createStore with applyMiddleware works', () => {
    const store = createStore(
      counterReducer,
      applyMiddleware(loggingMiddleware)
    );
    expect(store.getState()).toBe(0);
  });

  test('dispatch works', () => {
    const store = createStore(counterReducer);
    store.dispatch(increment());
    expect(store.getState()).toBe(1);
    store.dispatch(decrement());
    expect(store.getState()).toBe(0);
  });

  test('combineReducers works', () => {
    const rootReducer = combineReducers({
      counter: counterReducer,
    });
    const store = createStore(rootReducer);
    expect(store.getState()).toEqual({ counter: 0 });
  });

  test('createAction works', () => {
    const incrementAction = increment();
    expect(incrementAction).toEqual({ type: 'INCREMENT' });
    const decrementAction = decrement();
    expect(decrementAction).toEqual({ type: 'DECREMENT' });
  });

  test('subscribe and dispatch work together', () => {
    const store = createStore(counterReducer);
    let state: number;
    store.subscribe(() => {
      state = store.getState();
    });
    store.dispatch(increment());
    expect(state).toBe(1);
  });
});

describe('applyMiddleware', () => {
  test('applyMiddleware works', () => {
    let middlewareCalled = false;
    const testMiddleware = (storeApi) => (next) => (action) => {
      middlewareCalled = true;
      return next(action);
    };
    const mockAction = { type: 'MOCK_ACTION' };
    const store = createStore(
      (state = {}, action) => state,
      applyMiddleware(testMiddleware)
    );
    store.dispatch(mockAction);
    expect(middlewareCalled).toBe(true);
  });

  test('applyMiddleware throws error when dispatching in middleware construction', () => {
    const testMiddleware: Middleware = (storeApi) => {
      storeApi.dispatch({ type: 'TEST' });
      return (next) => (action) => next(action);
    };
    const createStoreWithMiddleware =
      applyMiddleware(testMiddleware)(createStore);
    expect(() =>
      createStoreWithMiddleware((state = {}, action) => state)
    ).toThrow('Dispatching while constructing your middleware is not allowed.');
  });
});

describe('createAction', () => {
  test('createAction without prepare function', () => {
    const type = 'TEST_ACTION';
    const payload = 'test payload';
    const actionCreator = createAction(type);
    const action = actionCreator(payload);
    expect(action).toEqual({ type, payload });
  });

  test('createAction with prepare function', () => {
    const type = 'TEST_ACTION';
    const payload = 'test payload';
    const prepare = (payload) => ({ payload, meta: 'test meta' });
    const actionCreator = createAction(type, prepare);
    const action = actionCreator(payload);
    expect(action).toEqual({ type, payload, meta: 'test meta' });
  });

  test('createAction with prepare function that returns undefined', () => {
    const type = 'TEST_ACTION';
    const prepare = () => undefined;
    const actionCreator = createAction(type, prepare);
    expect(() => actionCreator()).toThrow(
      'prepare function did not return an object'
    );
  });
});

import { useDispatch, useSelector } from './redux';

describe('useDispatch and useSelector', () => {
  test('useDispatch returns the dispatch function from the store', () => {
    const store = createStore((state = {}, action) => state);
    const context = { store };
    const dispatch = useDispatch(context);
    expect(dispatch).toBe(store.dispatch);
  });

  test('useSelector returns the selected state', () => {
    const initialState = { value: 1 };
    const store = createStore((state = initialState, action) => state);
    const context = { store };
    const selector = (state) => state.value;
    const selected = useSelector(context, selector);
    expect(selected).toBe(initialState.value);
  });
});

describe('combineReducers', () => {
  test('combineReducers works', () => {
    const reducer1 = (state = 0, action) => {
      switch (action.type) {
        case 'INCREMENT':
          return state + 1;
        default:
          return state;
      }
    };
    const reducer2 = (state = 0, action) => {
      switch (action.type) {
        case 'DECREMENT':
          return state - 1;
        default:
          return state;
      }
    };
    const rootReducer = combineReducers({
      counter1: reducer1,
      counter2: reducer2,
    });
    const store = createStore(rootReducer);
    store.dispatch({ type: 'INCREMENT' });
    store.dispatch({ type: 'DECREMENT' });
    expect(store.getState()).toEqual({ counter1: 1, counter2: -1 });
  });

  test('combineReducers returns previous state if no changes', () => {
    const reducer1 = (state = 0, action) => {
      switch (action.type) {
        case 'INCREMENT':
          return state + 1;
        default:
          return state;
      }
    };
    const reducer2 = (state = 0, action) => {
      switch (action.type) {
        case 'DECREMENT':
          return state - 1;
        default:
          return state;
      }
    };
    const rootReducer = combineReducers({
      counter1: reducer1,
      counter2: reducer2,
    });
    const store = createStore(rootReducer);
    store.dispatch({ type: 'INCREMENT' });
    store.dispatch({ type: 'UNKNOWN_ACTION' });
    expect(store.getState()).toEqual({ counter1: 1, counter2: 0 });
  });
});

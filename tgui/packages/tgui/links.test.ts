import { captureExternalLinks } from './links';

describe('captureExternalLinks', () => {
  let addEventListenerSpy;
  let clickHandler;

  beforeEach(() => {
    addEventListenerSpy = jest.spyOn(document, 'addEventListener');
    captureExternalLinks();
    clickHandler = addEventListenerSpy.mock.calls[0][1];
  });

  afterEach(() => {
    addEventListenerSpy.mockRestore();
  });

  it('should subscribe to document clicks', () => {
    expect(addEventListenerSpy).toHaveBeenCalledWith(
      'click',
      expect.any(Function)
    );
  });

  it('should preventDefault and send a message when a non-BYOND external link is clicked', () => {
    const externalLink = {
      tagName: 'A',
      getAttribute: () => 'https://example.com',
      parentElement: document.body,
    };
    const byond = { sendMessage: jest.fn() };
    // @ts-ignore
    global.Byond = byond;

    const evt = { target: externalLink, preventDefault: jest.fn() };
    clickHandler(evt);

    expect(evt.preventDefault).toHaveBeenCalled();
    expect(byond.sendMessage).toHaveBeenCalledWith({
      type: 'openLink',
      url: 'https://example.com',
    });
  });

  it('should not preventDefault or send a message when a BYOND link is clicked', () => {
    const byondLink = {
      tagName: 'A',
      getAttribute: () => 'byond://server-address',
      parentElement: document.body,
    };
    const byond = { sendMessage: jest.fn() };
    // @ts-ignore
    global.Byond = byond;

    const evt = { target: byondLink, preventDefault: jest.fn() };
    clickHandler(evt);

    expect(evt.preventDefault).not.toHaveBeenCalled();
    expect(byond.sendMessage).not.toHaveBeenCalled();
  });

  it('should add https:// to www links', () => {
    const wwwLink = {
      tagName: 'A',
      getAttribute: () => 'www.example.com',
      parentElement: document.body,
    };
    const byond = { sendMessage: jest.fn() };
    // @ts-ignore
    global.Byond = byond;

    const evt = { target: wwwLink, preventDefault: jest.fn() };
    clickHandler(evt);

    expect(byond.sendMessage).toHaveBeenCalledWith({
      type: 'openLink',
      url: 'https://www.example.com',
    });
  });

  it('should not preventDefault or send a message when the target is not an anchor tag', () => {
    const nonAnchorTag = {
      tagName: 'DIV',
      getAttribute: () => 'https://example.com',
      parentElement: {
        tagName: 'A',
        getAttribute: () => 'https://example.com',
      },
    };
    const byond = { sendMessage: jest.fn() };
    // @ts-ignore
    global.Byond = byond;

    const evt = { target: nonAnchorTag, preventDefault: jest.fn() };
    clickHandler(evt);

    expect(evt.preventDefault).toHaveBeenCalled();
    expect(byond.sendMessage).toHaveBeenCalledWith({
      type: 'openLink',
      url: 'https://example.com',
    });
  });

  it('should not preventDefault or send a message when the target is the body of the document', () => {
    const body = document.body;
    const byond = { sendMessage: jest.fn() };
    // @ts-ignore
    global.Byond = byond;

    const evt = { target: body, preventDefault: jest.fn() };
    clickHandler(evt);

    expect(evt.preventDefault).not.toHaveBeenCalled();
    expect(byond.sendMessage).not.toHaveBeenCalled();
  });

  it('should not preventDefault or send a message when the anchor tag does not have an href attribute', () => {
    const anchorWithoutHref = {
      tagName: 'A',
      getAttribute: () => null,
      parentElement: document.body,
    };
    const byond = { sendMessage: jest.fn() };
    // @ts-ignore
    global.Byond = byond;

    const evt = { target: anchorWithoutHref, preventDefault: jest.fn() };
    clickHandler(evt);

    expect(evt.preventDefault).toHaveBeenCalled();
    expect(byond.sendMessage).toHaveBeenCalledWith({
      type: 'openLink',
      url: '',
    });
  });
});

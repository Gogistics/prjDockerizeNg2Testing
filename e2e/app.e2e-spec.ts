import { PrjDockerizeNg2TestingPage } from './app.po';

describe('prj-dockerize-ng2-testing App', () => {
  let page: PrjDockerizeNg2TestingPage;

  beforeEach(() => {
    page = new PrjDockerizeNg2TestingPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});

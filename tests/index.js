describe("Application", function () {
    this.timeout(100000);

    it("app", function (done) {
        require("dotenv").config();

        done();
    });

    // describe("Game", function() {

    //     require("./Game/attributes");
    // });

    describe("Flow", function () {
        describe("Signup", function () {
            it("app", function (done) {
                done();
            });
        });

        /*describe("Login", function () {
            require("./Auth/login");
        });

        describe("Auction", function () {
            require("./Auction/auction");
        });*/
    });
});

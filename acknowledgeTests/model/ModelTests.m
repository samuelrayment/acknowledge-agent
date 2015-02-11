#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Model.h"

SpecBegin(Model)

describe(@"RAGState", ^{
    it(@"Should convert to a string", ^{
        expect(RAGStateToString(Red)).to.equal(@"Red");
        expect(RAGStateToString(Amber)).to.equal(@"Amber");
        expect(RAGStateToString(Green)).to.equal(@"Green");
        expect(RAGStateToString(Disconnected)).to.equal(@"Disconnected");
    });
    
    it(@"Should convert to a char", ^{
        expect(RAGStateToChar(Red)).to.equal('R');
        expect(RAGStateToChar(Amber)).to.equal('A');
        expect(RAGStateToChar(Green)).to.equal('G');
        expect(RAGStateToChar(Disconnected)).to.equal('D');
    });
    
    it(@"Should convert to a RAGState from a string", ^{
        expect(RAGStateFromString(@"Red")).to.equal(Red);
        expect(RAGStateFromString(@"Amber")).to.equal(Amber);
        expect(RAGStateFromString(@"Green")).to.equal(Green);
    });
});

SpecEnd
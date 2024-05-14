import SwiftUI

struct CarbsView: View {
    @EnvironmentObject var state: WatchStateModel

    enum Selection: String {
        case carbs, protein, fat
    }

    @State var selection: Selection = .carbs
    @State var carbAmount = 0.0
    @State var fatAmount = 0.0
    @State var proteinAmount = 0.0

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.bgDarkBlue, Color.bgDarkerDarkBlue, Color.bgDarkBlue]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimum = 0
        formatter.maximum = (state.maxCOB ?? 120) as NSNumber
        formatter.maximumFractionDigits = 0
        formatter.allowsFloats = false
        return formatter
    }

    var body: some View {
        VStack {
            carbs
            if state.displayFatAndProteinOnWatch {
                Spacer()
                fat
                Spacer()
                protein
            }
            buttonStack
        }
        .background(backgroundGradient) // Apply gradient to the entire VStack
        .onAppear { carbAmount = Double(state.carbsRequired ?? 0) }
    }

    var carbs: some View {
        nutrientView(nutrientIcon: "🥨", amount: $carbAmount, maxAmount: Double(state.maxCOB ?? 120))
    }

    var protein: some View {
        nutrientView(nutrientIcon: "🍗", amount: $proteinAmount, maxAmount: 240, foregroundColor: .red)
    }

    var fat: some View {
        nutrientView(nutrientIcon: "🧀", amount: $fatAmount, maxAmount: 240, foregroundColor: .loopYellow)
    }

    private func nutrientView(nutrientIcon: String, amount: Binding<Double>, maxAmount: Double, foregroundColor: Color = .primary) -> some View {
        HStack {
            Button {
                WKInterfaceDevice.current().play(.click)
                amount.wrappedValue = max(amount.wrappedValue - 5, 0)
            } label: {
                Image(systemName: "minus")
            }
            .buttonStyle(.borderless).padding(.leading, 5)

            Spacer()
            Text(nutrientIcon)
            Spacer()

            Text(numberFormatter.string(from: amount.wrappedValue as NSNumber)! + " g")
                .font(.title)
                .foregroundStyle(foregroundColor)
                .focusable(true)
                .digitalCrownRotation(amount, from: 0, through: maxAmount, by: 1, sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true)

            Spacer()

            Button {
                WKInterfaceDevice.current().play(.click)
                amount.wrappedValue = min(amount.wrappedValue + 5, maxAmount)
            } label: {
                Image(systemName: "plus")
            }
            .buttonStyle(.borderless).padding(.trailing, 5)
        }
        .minimumScaleFactor(0.7)
        .onTapGesture {
            selection = Selection(rawValue: nutrientIcon) ?? .carbs
        }
    }

    var buttonStack: some View {
        HStack(spacing: 25) {
            Button {
                WKInterfaceDevice.current().play(.click)
                // Confirm and save the meal
                let amounts = [carbAmount, fatAmount, proteinAmount].map { Int($0.rounded()) }
                state.addMeal(amounts[0], fat: amounts[1], protein: amounts[2])
            } label: {
                Text("Save")
            }
            .buttonStyle(.borderless)
            .font(.callout)
            .foregroundColor((carbAmount > 0 || fatAmount > 0 || proteinAmount > 0) ? .blue : .secondary)
            .disabled(carbAmount <= 0 && fatAmount <= 0 && proteinAmount <= 0)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.top)
    }
}

struct CarbsView_Previews: PreviewProvider {
    static var previews: some View {
        let state = WatchStateModel()
        state.carbsRequired = 120
        return Group {
            CarbsView().environmentObject(state)
        }
    }
}
